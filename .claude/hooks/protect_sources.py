#!/usr/bin/env python3
"""PreToolUse hook (Edit/Write/NotebookEdit/Bash): bảo vệ nguồn chỉ đọc và tệp trạng thái dùng chung.

Căn cứ: AGENTS.md mục "Bảo vệ nguồn và bằng chứng", tickets/LANES.md mục 4, PROJECT.md A4/B06.
- deny: data/raw/, chapter.docx, 00. Book/outline*.docx, ../99. Archive/, ghi đè bản lưu trong archive/,
        Write cả tệp hoặc lệnh shell ghi lên tickets/TASKS.md, LOG.md, CHAPTERS.md,
        git ghi khi thư mục dự án nằm trong Google Drive (B06).
- ask:  _project/data/ (dữ liệu chuẩn có SHA), _project/data_incoming/, renv.lock.
Lệnh Bash được kiểm theo heuristic (chuyển hướng >, rm/mv/cp/tee/sed -i, mã nội tuyến python/R/awk);
script R/Python chạy từ tệp thì hook không nhìn vào bên trong.
Lỗi nội bộ của hook: không chặn (exit 1, cảnh báo ra stderr).
"""
import glob
import json
import os
import re
import shlex
import sys

DENY_RULES = [
    (re.compile(r"^(0\d\. Chuong_0\d/)?data/raw(/|$)"), "`data/raw/` chỉ đọc (AGENTS.md: Bảo vệ nguồn). Ghi dữ liệu dẫn xuất vào `data/derived/` hoặc `results/<mã>_<ts>/`."),
    (re.compile(r"^0\d\. Chuong_0\d/chapter\.docx$"), "`chapter.docx` là bản gốc, không ghi đè. Sửa `chapter.md`; docx dựng vào `release/`."),
    (re.compile(r"^00\. Book/outline[^/]*\.docx$"), "`00. Book/outline*.docx` chỉ đọc (đề cương chuẩn)."),
]
ASK_RULES = [
    (re.compile(r"^_project/data/"), "`_project/data/` là dữ liệu chuẩn khoá SHA (B02); chỉ L0 thay, kèm DATA_MANIFEST.csv và dòng LOG."),
    (re.compile(r"^_project/data_incoming/"), "`_project/data_incoming/` là dữ liệu thô tác giả gửi; thường chỉ đọc."),
    (re.compile(r"^renv\.lock$"), "`renv.lock` do L0 quản lý (B04); làn không cài/gỡ gói (LANES.md mục 6)."),
]
SHARED = re.compile(r"^(tickets/TASKS\.md|LOG\.md|CHAPTERS\.md)$")
BACKUP = re.compile(r"^(0\d\. Chuong_0\d/|_project/)archive/")

SHARED_MSG = "Tệp dùng chung: chỉ sửa bằng công cụ Edit, đúng mục/dòng của làn mình, đọc lại ngay trước khi sửa (LANES.md mục 4)."
BACKUP_MSG = "Bản lưu trong `archive/` không ghi đè/xoá; lưu bản mới với hậu tố ngày, ví dụ `<tên>_<YYYYMMDD>_pre-<việc>.md`."
EXT_ARCHIVE_MSG = "`../99. Archive/` chỉ đọc."

# Tên dùng để dò trong mã nội tuyến (python -c, Rscript -e, awk '...')
INLINE_PATH = re.compile(r"data/raw/|chapter\.docx|outline[^/'\"]*\.docx|99\. Archive|TASKS\.md|LOG\.md|CHAPTERS\.md|_project/data/|renv\.lock")
INLINE_WRITE = re.compile(
    r"open\([^)]*['\"][wax+]|\.write|write[._(]|writeLines|fwrite|saveRDS|file\.(copy|remove|rename)|unlink"
    r"|shutil|os\.(remove|rename|replace)|to_csv|to_excel|sink\(|>"
)
INTERPRETERS = {"python", "python3", "Rscript", "R", "awk", "gawk", "perl", "node", "ruby"}
DELETE_CMDS = {"rm", "rmdir", "unlink", "shred", "truncate", "mv", "tee"}
COPY_CMDS = {"cp", "rsync", "ln", "install", "ditto"}
INPLACE_CMDS = {"sed", "gsed", "perl"}
GIT_WRITE = {"commit", "pull", "push", "checkout", "switch", "reset", "restore", "clean", "merge", "rebase", "stash", "rm", "mv", "add", "cherry-pick", "revert", "am", "apply"}
SEPARATORS = {";", "&&", "||", "|", "&", "(", ")", "|&"}
REDIRECTS = {">", ">>", ">|", "&>", "&>>"}
PREFIX_CMDS = {"sudo", "command", "env", "time", "nohup", "nice", "exec"}


def project_root(data):
    root = os.environ.get("CLAUDE_PROJECT_DIR") or data.get("cwd") or os.getcwd()
    return os.path.realpath(root)


def resolve(path, cwd):
    return os.path.realpath(os.path.join(cwd, os.path.expanduser(path)))


def relpath(abs_path, root):
    if abs_path == root:
        return ""
    if abs_path.startswith(root + os.sep):
        return abs_path[len(root) + 1:].replace(os.sep, "/")
    return None


def classify(abs_path, root, mode):
    """mode: 'edit' | 'write' | 'shell' — trả (decision, reason) hoặc None."""
    ext_archive = os.path.join(os.path.dirname(root), "99. Archive")
    if abs_path == ext_archive or abs_path.startswith(ext_archive + os.sep):
        return ("deny", EXT_ARCHIVE_MSG)
    rel = relpath(abs_path, root)
    if rel is None:
        return None
    for rx, msg in DENY_RULES:
        if rx.search(rel):
            return ("deny", msg)
    exists = os.path.exists(abs_path)
    if SHARED.match(rel) and mode in ("write", "shell"):
        if mode == "shell" or exists:
            return ("deny", SHARED_MSG)
    if BACKUP.search(rel) and exists and not os.path.isdir(abs_path):
        return ("deny", BACKUP_MSG)
    for rx, msg in ASK_RULES:
        if rx.search(rel):
            return ("ask", msg)
    return None


def contains_protected(abs_dir, root):
    """rm -rf/mv trên thư mục chứa tệp được bảo vệ (vd. cả thư mục chương)."""
    if root == abs_dir or root.startswith(abs_dir + os.sep):
        return ("deny", "Lệnh xoá/chuyển bao trùm cả thư mục dự án.")
    if not os.path.isdir(abs_dir):
        return None
    for dirpath, dirnames, filenames in os.walk(abs_dir):
        for name in dirnames + filenames:
            hit = classify(os.path.join(dirpath, name), root, "shell")
            if hit and hit[0] == "deny":
                return ("deny", "Thư mục chứa tệp được bảo vệ (`%s`): %s" % (name, hit[1]))
    return None


def worst(a, b):
    order = {None: 0, "ask": 1, "deny": 2}
    return a if order[a[0] if a else None] >= order[b[0] if b else None] else b


def expand(token, cwd):
    if any(ch in token for ch in "*?["):
        hits = glob.glob(os.path.join(cwd, os.path.expanduser(token)))
        if hits:
            return [os.path.realpath(h) for h in hits]
    return [resolve(token, cwd)]


def check_targets(tokens, cwd, root, deep=False):
    result = None
    for tok in tokens:
        for abs_path in expand(tok, cwd):
            result = worst(result, classify(abs_path, root, "shell"))
            if deep:
                result = worst(result, contains_protected(abs_path, root))
    return result


def in_google_drive(root):
    return bool(re.search(r"Google ?Drive|CloudStorage|My Drive", root))


def check_bash(command, cwd, root):
    try:
        lexer = shlex.shlex(command.replace("\n", " ; "), posix=True, punctuation_chars=True)
        lexer.whitespace_split = True
        tokens = list(lexer)
    except ValueError:
        if INLINE_PATH.search(command) and INLINE_WRITE.search(command):
            return ("ask", "Không phân tích được lệnh shell; lệnh có vẻ ghi vào tệp được bảo vệ.")
        return None

    result = None
    segment = []
    for tok in tokens + [";"]:
        if tok not in SEPARATORS:
            segment.append(tok)
            continue
        if not segment:
            continue
        words, redirect_targets = [], []
        i = 0
        while i < len(segment):
            if segment[i] in REDIRECTS and i + 1 < len(segment):
                redirect_targets.append(segment[i + 1])
                i += 2
                continue
            if segment[i] in (">&", "<", "<<", "<<<") and i + 1 < len(segment):
                i += 2
                continue
            words.append(segment[i])
            i += 1
        segment = []
        result = worst(result, check_targets([t for t in redirect_targets if not t.startswith("/dev/")], cwd, root))

        while words and (re.match(r"^\w+=", words[0]) or words[0] in PREFIX_CMDS):
            words = words[1:]
        if not words:
            continue
        cmd, args = os.path.basename(words[0]), words[1:]
        paths = [a for a in args if not a.startswith("-")]

        if cmd == "cd":
            if paths and paths[0] != "-":
                cwd = resolve(paths[0], cwd)
        elif cmd in DELETE_CMDS:
            result = worst(result, check_targets(paths, cwd, root, deep=cmd in ("rm", "rmdir", "mv")))
        elif cmd in COPY_CMDS and paths:
            result = worst(result, check_targets(paths[-1:], cwd, root))
        elif cmd in INPLACE_CMDS and any(a.startswith("-i") or a.startswith("--in-place") for a in args):
            result = worst(result, check_targets(paths, cwd, root))
        elif cmd == "git" and in_google_drive(root):
            rest = list(args)
            while rest and rest[0].startswith("-"):
                rest = rest[2:] if rest[0] in ("-C", "-c") else rest[1:]
            sub = rest[0] if rest else ""
            if sub in GIT_WRITE:
                result = worst(result, ("deny", "Repo git trong Google Drive đang hỏng (B06, PROJECT.md A4): không chạy `git %s` ở đây." % sub))

        if cmd in INTERPRETERS:
            for a in args:
                if INLINE_PATH.search(a) and INLINE_WRITE.search(a):
                    rel_hit = INLINE_PATH.search(a).group(0)
                    decision = "ask" if rel_hit in ("_project/data/", "renv.lock") else "deny"
                    result = worst(result, (decision, "Mã nội tuyến có vẻ ghi vào `%s` (tệp chỉ đọc hoặc dùng chung). Dùng Edit cho tệp trạng thái; dữ liệu dẫn xuất ghi vào `results/`." % rel_hit))
    return result


def main():
    data = json.load(sys.stdin)
    tool = data.get("tool_name", "")
    tin = data.get("tool_input", {}) or {}
    root = project_root(data)
    cwd = os.path.realpath(data.get("cwd") or root)

    if tool == "Bash":
        result = check_bash(tin.get("command", ""), cwd, root)
    elif tool in ("Edit", "MultiEdit", "Write", "NotebookEdit"):
        path = tin.get("file_path") or tin.get("notebook_path")
        if not path:
            return 0
        result = classify(resolve(path, cwd), root, "write" if tool == "Write" else "edit")
    else:
        return 0

    if result:
        decision, reason = result
        print(json.dumps({
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": decision,
                "permissionDecisionReason": "[protect_sources] " + reason,
            }
        }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as exc:  # hook lỗi thì không chặn công việc
        print("protect_sources hook lỗi (không chặn): %r" % (exc,), file=sys.stderr)
        sys.exit(1)
