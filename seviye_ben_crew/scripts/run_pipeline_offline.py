"""
Crew görev sırasını ofline üretir (API anahtarı yokken).
Sıra: ekonomi -> içerik -> flutter planı
Canlı CrewAI için: seviye_ben_crew/.env içine OPENAI_API_KEY yazıp `crewai run`
"""

from __future__ import annotations

import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'output'
APP_ASSETS = ROOT.parent / 'seviye_ben' / 'assets' / 'content'


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    content = OUT / '02_icerik.json'
    if not content.exists():
        raise SystemExit('02_icerik.json yok — önce içerik dosyasını oluştur.')

    APP_ASSETS.mkdir(parents=True, exist_ok=True)
    target = APP_ASSETS / 'seviye_ben_content.json'
    shutil.copyfile(content, target)

    plan = OUT / 'seviye_ben_plan.md'
    summary = {
        'steps': [
            '01_ekonomi.md',
            '02_icerik.json',
            'seviye_ben_plan.md',
            str(target.relative_to(ROOT.parent)),
        ],
        'habits': len(json.loads(content.read_text(encoding='utf-8'))['habits']),
        'equipment': len(json.loads(content.read_text(encoding='utf-8'))['equipment']),
        'plan_exists': plan.exists(),
    }
    (OUT / 'pipeline_result.json').write_text(
        json.dumps(summary, ensure_ascii=False, indent=2),
        encoding='utf-8',
    )
    print('Pipeline tamam:')
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
