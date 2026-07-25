from crewai import Agent, Crew, Process, Task
from crewai.project import CrewBase, agent, crew, task
from crewai.agents.agent_builder.base_agent import BaseAgent


@CrewBase
class SeviyeBenCrew:
    """SeviyeBen içerik ve mimari planlama ekibi."""

    agents: list[BaseAgent]
    tasks: list[Task]

    @agent
    def game_designer(self) -> Agent:
        return Agent(
            config=self.agents_config['game_designer'],  # type: ignore[index]
            verbose=True,
        )

    @agent
    def content_writer(self) -> Agent:
        return Agent(
            config=self.agents_config['content_writer'],  # type: ignore[index]
            verbose=True,
        )

    @agent
    def flutter_architect(self) -> Agent:
        return Agent(
            config=self.agents_config['flutter_architect'],  # type: ignore[index]
            verbose=True,
        )

    @task
    def design_economy_task(self) -> Task:
        return Task(
            config=self.tasks_config['design_economy_task'],  # type: ignore[index]
        )

    @task
    def write_content_task(self) -> Task:
        return Task(
            config=self.tasks_config['write_content_task'],  # type: ignore[index]
        )

    @task
    def flutter_plan_task(self) -> Task:
        return Task(
            config=self.tasks_config['flutter_plan_task'],  # type: ignore[index]
            output_file='output/seviye_ben_plan.md',
        )

    @crew
    def crew(self) -> Crew:
        return Crew(
            agents=self.agents,
            tasks=self.tasks,
            process=Process.sequential,
            verbose=True,
        )
