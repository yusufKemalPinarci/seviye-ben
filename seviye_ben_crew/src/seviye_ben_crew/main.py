#!/usr/bin/env python
"""SeviyeBen Crew giriş noktası — sprint girdileriyle sırayla 3 agent."""

from __future__ import annotations

import argparse
import sys
import warnings
from datetime import datetime

from seviye_ben_crew.crew import SeviyeBenCrew

warnings.filterwarnings('ignore', category=SyntaxWarning, module='pysbd')


def _default_inputs(
    *,
    sprint_id: str = '32',
    sprint_code: str = 'F4',
    topic: str | None = None,
    acceptance: str = 'Dahili / kapalı test → üretim',
    out_start: int = 90,
) -> dict[str, str]:
    code = sprint_code.upper()
    topic = topic or f'SeviyeBen sprint {sprint_id} ({code})'
    return {
        'topic': topic,
        'current_year': str(datetime.now().year),
        'sprint_id': str(sprint_id),
        'sprint_code': code,
        'acceptance': acceptance,
        'output_ekonomi': f'{out_start}_sprint{sprint_id}_ekonomi.md',
        'output_icerik': f'{out_start + 1}_sprint{sprint_id}_icerik.md',
        'output_plan': f'{out_start + 2}_sprint{sprint_id}_plan.md',
    }


def run():
    """game_designer → content_writer → flutter_architect."""
    parser = argparse.ArgumentParser(description='SeviyeBen sprint crew')
    parser.add_argument('--sprint', default='32', help='Sprint numarası (örn. 32)')
    parser.add_argument('--code', default='F4', help='ROADMAP kodu (örn. F4)')
    parser.add_argument('--topic', default=None, help='Sprint konusu')
    parser.add_argument('--acceptance', default='Dahili / kapalı test → üretim')
    parser.add_argument(
        '--out-start',
        type=int,
        default=90,
        help='İlk çıktı dosya numarası (ekonomi)',
    )
    args, _ = parser.parse_known_args()

    inputs = _default_inputs(
        sprint_id=args.sprint,
        sprint_code=args.code,
        topic=args.topic,
        acceptance=args.acceptance,
        out_start=args.out_start,
    )
    try:
        SeviyeBenCrew().crew().kickoff(inputs=inputs)
    except Exception as e:
        raise Exception(f'Crew çalıştırılırken hata: {e}') from e


def train():
    inputs = _default_inputs()
    try:
        SeviyeBenCrew().crew().train(
            n_iterations=int(sys.argv[1]),
            filename=sys.argv[2],
            inputs=inputs,
        )
    except Exception as e:
        raise Exception(f'Eğitim hatası: {e}') from e


def replay():
    try:
        SeviyeBenCrew().crew().replay(task_id=sys.argv[1])
    except Exception as e:
        raise Exception(f'Replay hatası: {e}') from e


def test():
    inputs = _default_inputs()
    try:
        SeviyeBenCrew().crew().test(
            n_iterations=int(sys.argv[1]),
            eval_llm=sys.argv[2],
            inputs=inputs,
        )
    except Exception as e:
        raise Exception(f'Test hatası: {e}') from e


if __name__ == '__main__':
    run()
