# ============================================================================
# GENAI106: Build Multi-Agent Systems with ADK
# Code snippets to ADD to the lab's existing agent.py files, in task order.
# This is not a standalone script — each block is pasted into the indicated
# file/location. Replace <PLACEHOLDER> values with your lab's values.
# ============================================================================


# ----------------------------------------------------------------------------
# TASK 1 (Cloud Shell Terminal): install ADK and lab code.
# ----------------------------------------------------------------------------
#   gcloud storage cp -r gs://<LAB_BUCKET>/* .
#   export PATH=$PATH:"/home/${USER}/.local/bin"
#   python3 -m pip install google-adk[otel-gcp]==1.30.0 \
#       -r adk_multiagent_systems/requirements.txt


# ----------------------------------------------------------------------------
# TASK 2 (parent_and_subagents/agent.py): build the hierarchy + guide routing.
# ----------------------------------------------------------------------------
# First create the .env (Terminal):
#   cd ~/adk_multiagent_systems
#   cat << EOF > parent_and_subagents/.env
#   GOOGLE_GENAI_USE_VERTEXAI=TRUE
#   GOOGLE_CLOUD_PROJECT=<PROJECT_ID>
#   GOOGLE_CLOUD_LOCATION=global
#   MODEL=gemini-3.5-flash
#   EOF
#   cp parent_and_subagents/.env workflow_agents/.env

# 2a) Add to the root_agent (steering) definition — wires the tree.
#     NOTE: no parent= on the children; the tree is defined only here.
sub_agents=[travel_brainstormer, attractions_planner]

# 2b) Add to the steering root_agent's `instruction` to guide transfers
#     (names refer to each agent's `name` value, not the Python variable):
"""
If they need help deciding, send them to
'travel_brainstormer'.
If they know what country they'd like to visit,
send them to the 'attractions_planner'.
"""
# Test:  adk run parent_and_subagents   (type 'exit' to quit)


# ----------------------------------------------------------------------------
# TASK 3 (parent_and_subagents/agent.py): save/read session state.
# ----------------------------------------------------------------------------

# 3a) Under the `# Tools` header — a tool that writes to session state.
from typing import List
from google.adk.tools import ToolContext   # (already imported in the lab file)

def save_attractions_to_state(
    tool_context: ToolContext,
    attractions: List[str]
) -> dict[str, str]:
    """Saves the list of attractions to state["attractions"].

    Args:
        attractions [str]: a list of strings to add to the list of attractions

    Returns:
        None
    """
    existing_attractions = tool_context.state.get("attractions", [])
    tool_context.state["attractions"] = existing_attractions + attractions
    return {"status": "success"}

# 3b) Attach the tool to the attractions_planner agent:
tools=[save_attractions_to_state]

# 3c) Add to the attractions_planner agent's `instruction`
#     ({ attractions? } is key templating; the ? avoids errors when unset):
"""
- When they reply, use your tool to save their selected attraction
and then provide more possible attractions.
- If they ask to view the list, provide a bulleted list of
{ attractions? } and then suggest some more.
"""
# Test:  adk web --allow_origins "regex:https://.*\.cloudshell\.dev"
#        -> open the State tab in the Dev UI to watch state["attractions"] grow.


# ============================================================================
# TASKS 4-6 operate on workflow_agents/agent.py (the movie-pitch system).
# ============================================================================

# ----------------------------------------------------------------------------
# TASK 4: run the starting SequentialAgent version (no code changes required —
# just launch and try it):
#   cd ~/adk_multiagent_systems
#   adk web --allow_origins "regex:https://.*\.cloudshell\.dev" --reload_agents
# Structure: greeter -> film_concept_team[researcher, screenwriter, file_writer]
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
# TASK 5 (workflow_agents/agent.py): add an iterative writers_room LoopAgent.
# ----------------------------------------------------------------------------

# 5a) Add imports:
from google.adk.tools import exit_loop
from google.adk.models import Gemini

# 5b) Add the critic agent under `# Agents` (do not overwrite existing agents):
critic = Agent(
    name="critic",
    model=Gemini(model=model_name, retry_options=RETRY_OPTIONS),
    description="Reviews the outline so that it can be improved.",
    instruction="""
    INSTRUCTIONS:
    Consider these questions about the PLOT_OUTLINE:
    - Does it meet a satisfying three-act cinematic structure?
    - Do the characters' struggles seem engaging?
    - Does it feel grounded in a real time period in history?
    - Does it sufficiently incorporate historical details from the RESEARCH?

    If the PLOT_OUTLINE does a good job with these questions, exit the writing loop with your 'exit_loop' tool.
    If significant improvements can be made, use the 'append_to_state' tool to add your feedback to the field 'CRITICAL_FEEDBACK'.
    Explain your decision and briefly summarize the feedback you have provided.

    PLOT_OUTLINE:
    { PLOT_OUTLINE? }

    RESEARCH:
    { research? }
    """,
    before_model_callback=log_query_to_model,
    after_model_callback=log_model_response,
    tools=[append_to_state, exit_loop]
)

# 5c) Add the writers_room LoopAgent above film_concept_team:
writers_room = LoopAgent(
    name="writers_room",
    description="Iterates through research and writing to improve a movie plot outline.",
    sub_agents=[
        researcher,
        screenwriter,
        critic
    ],
    max_iterations=5,   # always cap the loop
)

# 5d) Update film_concept_team to run the loop, then the file_writer:
film_concept_team = SequentialAgent(
    name="film_concept_team",
    description="Write a film plot outline and save it as a text file.",
    sub_agents=[
        writers_room,
        file_writer
    ],
)


# ----------------------------------------------------------------------------
# TASK 6 (workflow_agents/agent.py): fan out & gather with a ParallelAgent.
# ----------------------------------------------------------------------------

# 6a) Add two report agents + the ParallelAgent under `# Agents`.
#     Each report agent uses output_key to store its whole response in state.
box_office_researcher = Agent(
    name="box_office_researcher",
    model=Gemini(model=model_name, retry_options=RETRY_OPTIONS),
    description="Considers the box office potential of this film",
    instruction="""
    PLOT_OUTLINE:
    { PLOT_OUTLINE? }

    INSTRUCTIONS:
    Write a report on the box office potential of a movie like that described in PLOT_OUTLINE based on the reported box office performance of other recent films.
    """,
    output_key="box_office_report"
)

casting_agent = Agent(
    name="casting_agent",
    model=Gemini(model=model_name, retry_options=RETRY_OPTIONS),
    description="Generates casting ideas for this film",
    instruction="""
    PLOT_OUTLINE:
    { PLOT_OUTLINE? }

    INSTRUCTIONS:
    Generate ideas for casting for the characters described in PLOT_OUTLINE
    by suggesting actors who have received positive feedback from critics and/or
    fans when they have played similar roles.
    """,
    output_key="casting_report"
)

preproduction_team = ParallelAgent(
    name="preproduction_team",
    sub_agents=[
        box_office_researcher,
        casting_agent
    ]
)

# 6b) Insert preproduction_team between writers_room and file_writer:
film_concept_team = SequentialAgent(
    name="film_concept_team",
    description="Write a film plot outline and save it as a text file.",
    sub_agents=[
        writers_room,
        preproduction_team,
        file_writer
    ],
)

# 6c) Replace the file_writer's `instruction` to gather all three outputs:
"""
INSTRUCTIONS:
- Create a marketable, contemporary movie title suggestion for the movie described in the PLOT_OUTLINE. If a title has been suggested in PLOT_OUTLINE, you can use it, or replace it with a better one.
- Use your 'write_file' tool to create a new txt file with the following arguments:
    - for a filename, use the movie title
    - Write to the 'movie_pitches' directory.
    - For the 'content' to write, include:
        - The PLOT_OUTLINE
        - The BOX_OFFICE_REPORT
        - The CASTING_REPORT

PLOT_OUTLINE:
{ PLOT_OUTLINE? }

BOX_OFFICE_REPORT:
{ box_office_report? }

CASTING_REPORT:
{ casting_report? }
"""
# Test in the Dev UI: + New Session -> hello -> a character idea.
# The system loops research/write/critique, runs box-office + casting in
# parallel, then writes the full pitch to ~/adk_multiagent_systems/movie_pitches/
