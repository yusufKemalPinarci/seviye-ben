#!/usr/bin/env python
"""CrewAI canlı koşu veya ofline pipeline."""

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def _has_llm_key() -> bool:
    keys = (
        'OPENAI_API_KEY',
        'ANTHROPIC_API_KEY',
        'GOOGLE_API_KEY',
        'GEMINI_API_KEY',
        'AZURE_OPENAI_API_KEY',
    )
    env_file = ROOT / '.env'
    if env_file.exists():
        for line in env_file.read_text(encoding='utf-8').splitlines():
            line = line.strip()
            if not line or line.startswith('#') or '=' not in line:
                continue
            k, _, v = line.partition('=')
            if k.strip() in keys and v.strip():
                return True
    return any(os.getenv(k) for k in keys)


def main() -> int:
    os.chdir(ROOT)
    if _has_llm_key():
        print('LLM anahtari bulundu -> crewai run')
        return subprocess.call(['crewai', 'run'], cwd=ROOT)

    print('LLM anahtari yok -> ofline pipeline (output/ paketini uygulamaya kopyalar).')
    print('Canli Crew icin: .env icine OPENAI_API_KEY yaz.')
    return subprocess.call(
        [sys.executable, str(ROOT / 'scripts' / 'run_pipeline_offline.py')],
        cwd=ROOT,
    )


if __name__ == '__main__':
    raise SystemExit(main())
