# 🔗 Resources & Useful Links — GENAI106

## Lab & Course Links

| Resource | Link |
|---|---|
| Skill Badge: Deploy an Agent with Agent Development Kit (ADK) | https://www.cloudskillsboost.google/ (search "Deploy an Agent with ADK") |
| ADK documentation | https://google.github.io/adk-docs/ |
| Prereq lab: Get started with Google ADK | https://www.cloudskillsboost.google/ (search "Get started with Google Agent Development Kit") |
| Prereq lab: Empower ADK agents with tools | https://www.cloudskillsboost.google/ (search "Empower ADK agents with tools") |

## Tools & Frameworks (deep-dive links)

| Tool | Link |
|---|---|
| ADK — Agents (definition, model, instruction) | https://google.github.io/adk-docs/agents/ |
| ADK — Multi-agent systems | https://google.github.io/adk-docs/agents/multi-agents/ |
| ADK — Workflow agents (Sequential / Loop / Parallel) | https://google.github.io/adk-docs/agents/workflow-agents/ |
| ADK — Sessions & State (incl. key templating) | https://google.github.io/adk-docs/sessions/state/ |
| ADK — Tools & ToolContext | https://google.github.io/adk-docs/tools/ |
| ADK — Callbacks (before/after model) | https://google.github.io/adk-docs/callbacks/ |
| ADK Python on GitHub | https://github.com/google/adk-python |
| Vertex AI documentation | https://cloud.google.com/vertex-ai/docs |
| Gemini models | https://ai.google.dev/gemini-api/docs/models |
| Agent Engine (deploy ADK agents) | https://cloud.google.com/vertex-ai/generative-ai/docs/agent-engine/overview |
| LangChain tools (Wikipedia) | https://python.langchain.com/docs/integrations/tools/ |

## Code & Data Used in This Lab

> The lab's code is copied from a session-specific Cloud Storage bucket
> (`gs://<LAB_BUCKET>/`) into your Cloud Shell home directory. No external
> datasets — the agents generate their own content.

### Directories in `adk_multiagent_systems/`

| Path | Contents |
|---|---|
| `parent_and_subagents/agent.py` | Tasks 2–3: the `steering` root agent with `travel_brainstormer` + `attractions_planner` sub-agents |
| `parent_and_subagents/.env` | Auth config: Gemini via Vertex AI, your project, model `gemini-3.5-flash` |
| `workflow_agents/agent.py` | Tasks 4–6: the movie-pitch system (`greeter` → `film_concept_team`) |
| `workflow_agents/.env` | Copy of the same auth config |
| `movie_pitches/` | Output directory where `file_writer` saves generated pitch `.txt` files |
| `requirements.txt` | Extra Python dependencies installed in Task 1 |

### Key ADK objects built in this lab

| Object | Type | Role |
|---|---|---|
| `steering` | root Agent | Routes travel users to a specialist sub-agent |
| `save_attractions_to_state` | tool function | Writes chosen attractions into session state |
| `greeter` | root Agent | Entry point of the movie-pitch system |
| `film_concept_team` | `SequentialAgent` | Ordered pipeline: writers_room → preproduction_team → file_writer |
| `writers_room` | `LoopAgent` | researcher → screenwriter → critic, up to 5 iterations |
| `critic` | Agent | Reviews the outline; calls `exit_loop` when it's good enough |
| `preproduction_team` | `ParallelAgent` | box_office_researcher ∥ casting_agent (concurrent) |
| `file_writer` | Agent | Titles the film and writes plot + both reports to a file |

## Files in This Folder

| File | Purpose |
|---|---|
| `README.md` | Full walkthrough — concepts, all six tasks, architecture diagrams, pro tips |
| `solutions.py` | Every code snippet to add, in task order, with file/location notes |
| `datasets-and-links.md` | This file — references and links |
