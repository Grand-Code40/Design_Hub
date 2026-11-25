"""Запуск Impeccable без PowerShell — для сред, где .ps1 запрещены (например, песочница Codex).

    python "<Design Hub>/tools/impeccable.py" context --target <файл>
    python "<Design Hub>/tools/impeccable.py" detect --json <файл-или-URL> [--viewport 390x844]

Делает то же, что Invoke-Impeccable.ps1: задаёт IMPECCABLE_SKILL_DIR, IMPECCABLE_HOME и IMPECCABLE_LIVE_COPY_AGENT
и вызывает движок с D:. Запускай из корня целевого проекта. Код выхода движка сохраняется: 2 — найдены проблемы,
1 — ошибка проверки, 0 — без основных замечаний.
"""
import os
import subprocess
import sys
from pathlib import Path

SKILL = (Path(__file__).resolve().parent / '..' / 'vendor' / 'impeccable').resolve()
HOME = Path('D:/DrawingAI_runs/design-hub-tools-2026-11-22/impeccable')
VERSION = (SKILL / 'scripts' / 'VERSION').read_text(encoding='utf-8').strip()
ENGINE = HOME / 'bin' / VERSION / 'impeccable.exe'

if __name__ == '__main__':
    if not ENGINE.is_file():
        sys.exit(f'Impeccable engine {VERSION} not found at {ENGINE}')
    env = dict(os.environ, IMPECCABLE_SKILL_DIR=str(SKILL), IMPECCABLE_HOME=str(HOME), IMPECCABLE_LIVE_COPY_AGENT='chat')
    sys.exit(subprocess.run([str(ENGINE), *sys.argv[1:]], env=env).returncode)
