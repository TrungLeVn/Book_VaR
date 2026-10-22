#!/usr/bin/env python3
"""Tự kiểm hook protect_sources.py. Chạy từ gốc dự án: python3 .claude/hooks/test_protect_sources.py"""
import json
import os
import subprocess
import sys

HOOK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "protect_sources.py")
ROOT = os.path.realpath(os.path.join(os.path.dirname(HOOK), "..", ".."))

CASES = [
    # (tool, input, kỳ vọng: None | "ask" | "deny")
    ("Edit", {"file_path": "01. Chuong_01/chapter.md"}, None),
    ("Edit", {"file_path": "01. Chuong_01/chapter.docx"}, "deny"),
    ("Write", {"file_path": "03. Chuong_03/data/raw/new.csv"}, "deny"),
    ("Write", {"file_path": "03. Chuong_03/data/derived/new.csv"}, None),
    ("Write", {"file_path": "00. Book/outline_v3.2.docx"}, "deny"),
    ("Write", {"file_path": "../99. Archive/x.md"}, "deny"),
    ("Write", {"file_path": "LOG.md"}, "deny"),
    ("Edit", {"file_path": "LOG.md"}, None),
    ("Edit", {"file_path": "tickets/TASKS.md"}, None),
    ("Write", {"file_path": "tickets/TASKS.md"}, "deny"),
    ("Edit", {"file_path": "_project/archive/INDEX_20261022.md"}, "deny"),
    ("Write", {"file_path": "_project/archive/CLAUDE_29991231_pre-x.md"}, None),
    ("Write", {"file_path": "_project/data/README.md"}, "ask"),
    ("Edit", {"file_path": "renv.lock"}, "ask"),
    ("Write", {"file_path": "results/C02-M3_20261023-0900/README.md"}, None),
    ("Bash", {"command": "tail -n 10 LOG.md"}, None),
    ("Bash", {"command": "grep -n Active tickets/TASKS.md | head"}, None),
    ("Bash", {"command": "sed -n 1,40p tickets/TASKS.md"}, None),
    ("Bash", {"command": "echo '- 22/10/2026 — [L3] x' >> LOG.md"}, "deny"),
    ("Bash", {"command": "sed -i '' 's/a/b/' tickets/TASKS.md"}, "deny"),
    ("Bash", {"command": "cat x > \"01. Chuong_01/chapter.docx\""}, "deny"),
    ("Bash", {"command": "rm -rf \"03. Chuong_03\""}, "deny"),
    ("Bash", {"command": "rm 0*/data/raw/*"}, "deny"),
    ("Bash", {"command": "cd \"03. Chuong_03\" && rm data/raw/vnindex_daily.csv"}, "deny"),
    ("Bash", {"command": "cp new.csv \"03. Chuong_03/data/raw/\""}, "deny"),
    ("Bash", {"command": "cp \"03. Chuong_03/data/raw/vnindex_daily.csv\" /tmp/x.csv"}, None),
    ("Bash", {"command": "cp \"01. Chuong_01/chapter.md\" \"01. Chuong_01/archive/chapter_20261023_pre-x.md\""}, None),
    ("Bash", {"command": "python3 -c \"open('LOG.md','a').write('x')\""}, "deny"),
    ("Bash", {"command": "python3 -c \"print(open('LOG.md').read()[-500:])\""}, None),
    ("Bash", {"command": "cp a.csv _project/data/vnindex_daily_20100104_20260520.csv"}, "ask"),
    ("Bash", {"command": "rm -rf results/B04_20261022-1448_verify/sandbox_tmp"}, None),
    ("Bash", {"command": "LANG=en_US.UTF-8 Rscript run_ch01_all.R 2>&1 | tee results/C01-M3_x/log.txt"}, None),
    ("Bash", {"command": "rm -rf ."}, "deny"),
]


def run(tool, tin, env_extra=None):
    env = dict(os.environ, CLAUDE_PROJECT_DIR=ROOT, **(env_extra or {}))
    payload = json.dumps({"tool_name": tool, "tool_input": tin, "cwd": ROOT})
    out = subprocess.run([sys.executable, HOOK], input=payload, capture_output=True, text=True, env=env)
    if out.returncode != 0:
        return "error: " + out.stderr.strip()
    if not out.stdout.strip():
        return None
    return json.loads(out.stdout)["hookSpecificOutput"]["permissionDecision"]


def main():
    fails = 0
    for tool, tin, want in CASES:
        got = run(tool, tin)
        ok = got == want
        fails += not ok
        print("%s %-5s %-70s want=%s got=%s" % ("OK " if ok else "FAIL", tool, list(tin.values())[0][:70], want, got))
    # git chỉ bị chặn khi thư mục dự án nằm trong Google Drive (B06)
    got = run("Bash", {"command": "git status"})
    print("%s git status (ngoài Drive) got=%s" % ("OK " if got is None else "FAIL", got))
    fails += got is not None
    print("\n%d/%d lỗi" % (fails, len(CASES) + 1))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
