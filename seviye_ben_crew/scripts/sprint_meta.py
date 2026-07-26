#!/usr/bin/env python
"""PROGRESS.md'den sonraki sprint meta bilgisini çıkar (Cursor / CLI için)."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PROGRESS = ROOT / 'docs' / 'PROGRESS.md'


def parse_progress(text: str) -> dict[str, str | int]:
    next_item = None
    for m in re.finditer(
        r'## Sonraki sprint.*?\n(?:.*?\n)*?1\.\s+\*\*(.+?)\*\*',
        text,
        re.DOTALL,
    ):
        next_item = m.group(1).strip()
        break

    code_m = re.search(r'\b([A-Z]\d+)\b', next_item or '')
    sprint_code = code_m.group(1) if code_m else 'X?'

    nums = re.search(
        r'Crew output son numaralar:.*?→\s*(\d+)\s*/\s*(\d+)\s*/\s*(\d+)',
        text,
    )
    if nums:
        out_start, out_mid, out_end = map(int, nums.groups())
    else:
        last = re.search(r'~\s*(\d+)\s*[–-]\s*(\d+)\s+sprint(\d+)', text)
        if last:
            out_end = int(last.group(2))
            sprint_n = int(last.group(3)) + 1
            out_start = out_end + 1
            out_mid = out_start + 1
            out_end = out_start + 2
        else:
            out_start, out_mid, out_end = 1, 2, 3
            sprint_n = 1
        return {
            'sprint_id': sprint_n,
            'sprint_code': sprint_code,
            'topic': next_item or '',
            'output_ekonomi': f'{out_start}_sprint{sprint_n}_ekonomi.md',
            'output_icerik': f'{out_mid}_sprint{sprint_n}_icerik.md',
            'output_plan': f'{out_end}_sprint{sprint_n}_plan.md',
            'out_start': out_start,
        }

    sprint_m = re.search(r'Yeni sprint\s+(\d+)', text)
    sprint_id = int(sprint_m.group(1)) if sprint_m else 1

    return {
        'sprint_id': sprint_id,
        'sprint_code': sprint_code,
        'topic': next_item or '',
        'output_ekonomi': f'{out_start}_sprint{sprint_id}_ekonomi.md',
        'output_icerik': f'{out_mid}_sprint{sprint_id}_icerik.md',
        'output_plan': f'{out_end}_sprint{sprint_id}_plan.md',
        'out_start': out_start,
    }


def _safe_print(text: str) -> None:
    enc = getattr(sys.stdout, 'encoding', None) or 'utf-8'
    sys.stdout.buffer.write((text + '\n').encode(enc, errors='replace'))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--json', action='store_true')
    args = parser.parse_args()
    if not PROGRESS.exists():
        print(f'PROGRESS yok: {PROGRESS}', file=sys.stderr)
        return 1
    meta = parse_progress(PROGRESS.read_text(encoding='utf-8'))
    if args.json:
        import json

        _safe_print(json.dumps(meta, ensure_ascii=False, indent=2))
    else:
        _safe_print(f"sprint_id={meta['sprint_id']}")
        _safe_print(f"sprint_code={meta['sprint_code']}")
        _safe_print(f"topic={meta['topic']}")
        _safe_print(f"out_start={meta['out_start']}")
        _safe_print(f"ekonomi={meta['output_ekonomi']}")
        _safe_print(f"icerik={meta['output_icerik']}")
        _safe_print(f"plan={meta['output_plan']}")
        _safe_print('')
        _safe_print(
            'crewai run / main.py ornek:\n'
            f"  --sprint {meta['sprint_id']} --code {meta['sprint_code']} "
            f"--out-start {meta['out_start']}"
        )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
