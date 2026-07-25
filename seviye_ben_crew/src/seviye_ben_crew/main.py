#!/usr/bin/env python
import sys
import warnings
from datetime import datetime

from seviye_ben_crew.crew import SeviyeBenCrew

warnings.filterwarnings('ignore', category=SyntaxWarning, module='pysbd')


def run():
    """SeviyeBen ekonomi + içerik + Flutter planı üretir."""
    inputs = {
        'topic': 'SeviyeBen ofline RPG alışkanlık ekonomisi ve başlangıç içeriği',
        'current_year': str(datetime.now().year),
    }
    try:
        SeviyeBenCrew().crew().kickoff(inputs=inputs)
    except Exception as e:
        raise Exception(f'Crew çalıştırılırken hata: {e}') from e


def train():
    inputs = {
        'topic': 'SeviyeBen ofline RPG alışkanlık ekonomisi',
        'current_year': str(datetime.now().year),
    }
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
    inputs = {
        'topic': 'SeviyeBen ofline RPG alışkanlık ekonomisi',
        'current_year': str(datetime.now().year),
    }
    try:
        SeviyeBenCrew().crew().test(
            n_iterations=int(sys.argv[1]),
            eval_llm=sys.argv[2],
            inputs=inputs,
        )
    except Exception as e:
        raise Exception(f'Test hatası: {e}') from e
