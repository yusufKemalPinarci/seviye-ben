# SeviyeBenCrew Crew

Welcome to the SeviyeBenCrew Crew project, powered by [crewAI](https://crewai.com). This template is designed to help you set up a multi-agent AI system with ease, leveraging the powerful and flexible framework provided by crewAI. Our goal is to enable your agents to collaborate effectively on complex tasks, maximizing their collective intelligence and capabilities.

## Installation

Ensure you have Python >=3.10 <3.14 installed on your system. This project uses [UV](https://docs.astral.sh/uv/) for dependency management and package handling, offering a seamless setup and execution experience.

First, if you haven't already, install uv:

```bash
pip install uv
```

Next, navigate to your project directory and install the dependencies:

(Optional) Lock the dependencies and install them by using the CLI command:
```bash
crewai install
```
### Customizing

1. `.env.example` dosyasını `.env` olarak kopyala
2. `OPENAI_API_KEY` (veya kullandığın LLM anahtarını) yaz

## Running

**Canlı CrewAI (LLM gerekir):**

```bash
crewai install
crewai run
```

Sıra: `game_designer` → `content_writer` → `flutter_architect`  
Çıktı: `output/seviye_ben_plan.md`

**Ofline pipeline (anahtar yokken, mevcut içerik paketini uygulamaya kopyalar):**

```bash
python scripts/run_pipeline_offline.py
```

Mevcut crew çıktıları: `output/01_ekonomi.md`, `output/02_icerik.json`, `output/seviye_ben_plan.md`

## Understanding Your Crew

The seviye_ben_crew Crew is composed of multiple AI agents, each with unique roles, goals, and tools. These agents collaborate on a series of tasks, defined in `config/tasks.yaml`, leveraging their collective skills to achieve complex objectives. The `config/agents.yaml` file outlines the capabilities and configurations of each agent in your crew.

## Support

For support, questions, or feedback regarding the SeviyeBenCrew Crew or crewAI.
- Visit our [documentation](https://docs.crewai.com)
- Reach out to us through our [GitHub repository](https://github.com/joaomdmoura/crewai)
- [Join our Discord](https://discord.com/invite/X4JWnZnxPb)
- [Chat with our docs](https://chatg.pt/DWjSBZn)

Let's create wonders together with the power and simplicity of crewAI.
