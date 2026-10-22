#!/usr/bin/env python3
"""Đọc tickets/TASKS.md + tickets/<mã>.md, liệt kê ticket sẵn sàng và dựng bản nháp prompt mở phiên.

Chạy từ gốc dự án (02. Drafts/):
  python3 .claude/skills/lane-handoff/ready_tickets.py               # ticket Sẵn sàng / Đang làm / Cần quyết định
  python3 .claude/skills/lane-handoff/ready_tickets.py --all         # thêm ticket đang bị chặn và lý do
  python3 .claude/skills/lane-handoff/ready_tickets.py --prompt C03-D1 [--surface Code|Cowork]
Chỉ đọc; không ghi tệp nào.
"""
import argparse
import csv
import os
import re
import sys

ITEM = re.compile(r"^- \[( |x)\] (?:~~)?\*\*(?P<code>[BC]\d{2}(?:-[A-Z0-9]+[a-z]?)?) — (?P<title>.+?)\*\*")
FIELD = re.compile(r"^\s{4}- (?P<key>[^:]+): (?P<val>.*)$")
CODE = re.compile(r"\b[BC]\d{2}(?:-(?:M\d[a-z]?|D\d|E))?\b")
HEAVY_R = re.compile(r"-M3[a-c]?$")


def parse_tasks(path):
    items, section, cur = [], None, None
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.rstrip("\n")
            if line.startswith("## "):
                section, cur = line[3:].strip(), None
                continue
            m = ITEM.match(line)
            if m:
                cur = {"code": m.group("code"), "title": m.group("title"), "section": section, "fields": {}}
                items.append(cur)
                continue
            f = FIELD.match(line)
            if f and cur is not None:
                cur["fields"][f.group("key").strip()] = f.group("val").strip()
    return items


def hard_deps(text):
    """Phần trước dấu ';', bỏ ngoặc đơn (ghi chú thứ tự). Trả (danh sách mã, có dải '…' không)."""
    head = text.split(";")[0]
    head = re.sub(r"\([^)]*\)", "", head)
    return CODE.findall(head), "…" in head


def assess(items):
    done = {i["code"] for i in items if i["section"] == "Done"}
    for it in items:
        f = it["fields"]
        status = f.get("Trạng thái", "")
        deps, has_range = hard_deps(f.get("Phụ thuộc", "—"))
        missing = [d for d in deps if d not in done]
        if it["section"] == "Done":
            state = "Xong"
        elif it["section"] == "Waiting On":
            state = "Cần quyết định"
        elif it["section"] == "Someday":
            state = "Hoãn"
        elif status.startswith("Đang làm"):
            state = "Đang làm"
        elif status.startswith("Sẵn sàng"):
            state = "Sẵn sàng (L0)"
        elif has_range:
            state = "Kiểm tay (dải phụ thuộc)"
        elif missing:
            state = "Chặn"
        else:
            state = "Sẵn sàng"
        it.update(state=state, missing=missing)
    return items


def show(items, show_all):
    rows = [i for i in items if i["section"] != "Done" and (show_all or i["state"] not in ("Chặn", "Hoãn"))]
    print("| Mã | Làn | Nơi làm | Trạng thái | R nặng? | Ghi chú |")
    print("|---|---|---|---|---|---|")
    for i in rows:
        f = i["fields"]
        heavy = "có thể" if f.get("Nơi làm") == "Code" and HEAVY_R.search(i["code"]) else ""
        note = "thiếu: " + ", ".join(i["missing"]) if i["state"] == "Chặn" else f.get("Trạng thái", f.get("Cần quyết định", ""))[:70]
        print("| %s | %s | %s | %s | %s | %s |" % (i["code"], f.get("Làn", "?"), f.get("Nơi làm", "?"), i["state"], heavy, note))
    blocked = sum(1 for i in items if i["state"] == "Chặn")
    if not show_all:
        print("\n(%d ticket đang bị chặn bởi phụ thuộc chưa Done — xem bằng --all)" % blocked)


def section(text, title):
    m = re.search(r"^## %s\s*\n(.*?)(?=^## |\Z)" % re.escape(title), text, re.S | re.M)
    return m.group(1).strip() if m else ""


def write_set(lane, code):
    if lane == "L0":
        return "`PROJECT.md`, `team/`, `AGENTS.md`, `CLAUDE.md`, `00. Book/`, `_project/`, `tickets/B*.md`, `tickets/LANES.md`, `results/B*`, `design/B*`, `reviews/*_book*`"
    m = re.match(r"L(\d)([abc]?)$", lane or "")
    if not m:
        return "[xem tickets/LANES.md mục 2–3]"
    x, part = m.group(1), m.group(2)
    if part:
        return "`analysis/ch0{x}/{p}_*/`, `results/C0{x}-M3{p}_*`, `tickets/{c}.md` (không sửa `chapter.md`, `analysis/ch0{x}/run_ch0{x}_all.R`){extra}".format(
            x=x, p=part, c=code, extra="; `analysis/common/` (chỉ L3b)" if lane == "L3b" else "")
    extra = "; `chapters/drafts/B09_*`" if x == "6" else ""
    return ("`0{x}. Chuong_0{x}/` (trừ `data/raw/`, `chapter.docx`), `analysis/ch0{x}/`, `results/C0{x}-*`, `design/C0{x}-*`, "
            "`chapters/drafts/C0{x}-*`, `context/ch0{x}_*`, `reviews/*ch0{x}*`, `tickets/C0{x}-*.md`{e}").format(x=x, e=extra)


def data_inputs(text, root):
    """Tệp trong _project/data/ được ticket nhắc tới, kèm SHA-256 (12 ký tự) từ DATA_MANIFEST.csv."""
    manifest = os.path.join(root, "_project", "data", "DATA_MANIFEST.csv")
    if not os.path.exists(manifest):
        return []
    out = []
    with open(manifest, encoding="utf-8") as fh:
        for row in csv.DictReader(fh):
            if row["file"] in text:
                out.append("`_project/data/%s` (%s phiên, SHA %s…)" % (row["file"], row["n_sessions"], row["sha256"][:12]))
    return out


def prompt(items, code, surface, root):
    it = next((i for i in items if i["code"] == code), None)
    if it is None:
        sys.exit("Không thấy %s trong tickets/TASKS.md" % code)
    f = it["fields"]
    lane = f.get("Làn", "?")
    where = f.get("Nơi làm", "Either")
    surface = surface or ("Cowork" if where == "Cowork" else "Code")
    tpath = os.path.join(root, "tickets", "%s.md" % code)
    ttext = open(tpath, encoding="utf-8").read() if os.path.exists(tpath) else ""
    cards = sorted(set(re.findall(r"team/agents/[\w-]+\.md", ttext)))
    inputs = data_inputs(ttext, root)
    output = section(ttext, "Đầu ra + tiêu chí nghiệm thu") or f.get("Đầu ra + tiêu chí", "")
    stop = section(ttext, "Dừng và báo Lead nếu")
    gate = f.get("Điểm duyệt", "—")

    warn = []
    if where not in (surface, "Either"):
        warn.append("CẢNH BÁO: ticket ghi Nơi làm = %s, prompt đang dựng cho %s." % (where, surface))
    if it["state"] in ("Chặn", "Kiểm tay (dải phụ thuộc)", "Cần quyết định", "Hoãn", "Xong"):
        warn.append("CẢNH BÁO: trạng thái = %s%s — chưa nên mở phiên." % (
            it["state"], (" (thiếu " + ", ".join(it["missing"]) + ")") if it["missing"] else ""))
    for w in warn:
        print(w, file=sys.stderr)

    lines = ["[%s] %s — %s" % (lane, code, surface), ""]
    lines.append("Dự án sách VaR, gốc `02. Drafts/`. Bạn là làn **%s** — %s. Ticket **%s — %s**." % (
        lane, "Lead sách" if lane == "L0" else "Lead của phạm vi ticket", code, it["title"]))
    read = "`PROJECT.md` → `tickets/LANES.md` (mục 1–6, 9) → mục %s trong `tickets/TASKS.md` → `tickets/%s.md`" % (code, code)
    if inputs:
        read += " → `_project/data/README.md`"
    read += " → 10 dòng cuối `LOG.md`"
    if cards:
        read += " → card " + ", ".join("`%s`" % c for c in cards)
    if surface == "Cowork":
        read += " → `CHAPTERS.md`"
    lines.append("Đọc lần lượt: " + read + ".")
    lines.append("Thuật ngữ/ký hiệu: `00. Book/glossary.md`, `notation.md`; tiêu đề theo `00. Book/architecture.md` (đề cương 3.2).")
    if inputs:
        lines.append("Đầu vào (kiểm SHA theo `_project/data/DATA_MANIFEST.csv` trước khi dùng): " + "; ".join(inputs) + ".")
    out = re.sub(r"^-\s*Đầu ra:\s*", "", " ".join(output.split())).replace(" - Tiêu chí:", ". Tiêu chí:")
    lines.append("Đầu ra: " + (out or "theo ticket") + ".")
    lines.append("Chỉ ghi vào: " + write_set(lane, code) + ". `tickets/TASKS.md`, `LOG.md`, `CHAPTERS.md`: chỉ Edit đúng mục/dòng của làn, đọc lại ngay trước khi sửa.")
    stops = ["điểm duyệt %s" % gate] if gate not in ("—", "") else []
    if stop:
        stops.append(" ".join(stop.split()))
    stops += ["mục `Cần quyết định`", "phụ thuộc chưa Done"]
    lines.append("Làm theo `lht-academic-suite:paper-team`, chế độ `to-approval`; ≤ 2 agent con. Dừng ở: " + "; ".join(stops) + ".")
    if surface == "Cowork":
        lines.append("Quy tắc (Cowork không tự đọc CLAUDE.md/AGENTS.md): `data/raw/`, `chapter.docx`, `00. Book/outline*.docx`, `../99. Archive/` chỉ đọc; "
                     "không bịa số, trích dẫn, quy định — thiếu nguồn ghi `[Missing Citation]`, số chưa có run ghi `[RESULT PENDING: <mã>]`; "
                     "lưu bản trước vào `archive/` trước khi sửa đáng kể `chapter.md`. Bước cần chạy R: ghi NOT RUN, chuyển sang Code.")
    lines.append("Cuối mỗi khối việc: sửa mục %s trong `tickets/TASKS.md` bằng Edit; thêm một dòng cuối `LOG.md`: `- DD/MM/YYYY — [%s] %s — …` (đã chạy vs đã kiểm, bước kế)." % (code, lane, code))
    print("```text\n" + "\n".join(lines) + "\n```")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--prompt", metavar="MÃ")
    ap.add_argument("--surface", choices=["Code", "Cowork"])
    a = ap.parse_args()
    root = os.path.abspath(a.root)
    items = assess(parse_tasks(os.path.join(root, "tickets", "TASKS.md")))
    if a.prompt:
        prompt(items, a.prompt, a.surface, root)
    else:
        show(items, a.all)


if __name__ == "__main__":
    main()
