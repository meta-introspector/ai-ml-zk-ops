**CRQ: Agent Rate Limit Management and Interaction Receipts**

**Problem/Goal:**
To enable the system to intelligently manage interactions with external agents (e.g., CoderabbitAI) by respecting their API rate limits, and to maintain a persistent record of these interactions directly within the relevant CRQ documents.

**Proposed Solution:**

1.  **Define Agent State and Persistence:**
    *   **Data Structure:** Create a new Rust struct, `AgentState`, to hold rate limit information for each agent (e.g., `last_command_timestamp`, `next_available_timestamp`, `remaining_calls`, `reset_time`).
    *   **Agent Identification:** Agents will be identified by unique IDs (e.g., "coderabbitai", "gemini", "human_user").
    *   **Persistence:** This `AgentState` data will be persisted to a dedicated file (e.g., `agent_state.json`) using JSON for easy reading and writing. This ensures state is maintained across `crq_table_generator` runs.

2.  **Integrate Agent State Management into `crq_table_generator`:**
    *   **Load State:** At the beginning of `main.rs`, load the `AgentState` from `agent_state.json`. If the file doesn't exist, initialize a default state.
    *   **Rate Limit Enforcement:**
        *   Before generating a `gh pr comment` command (or any other agent interaction), check the `AgentState` for that agent.
        *   If the agent's rate limit is exceeded or the `next_available_timestamp` is in the future, skip generating the command for that specific CRQ and record "Rate Limited" as the outcome.
        *   Otherwise, proceed with command generation.
    *   **Update State:** After a command is generated (and assuming it's about to be executed), update the `AgentState` for the relevant agent (e.g., record the timestamp of the last command sent).
    *   **Persist State:** Before exiting, save the updated `AgentState` back to `agent_state.json`.

3.  **Implement CRQ Receipt Mechanism:**
    *   **Receipt Format:** Define a standard Markdown format for a "receipt" to be appended to the CRQ file. This could be a new section like `### Agent Interactions` containing:
        *   Timestamp of interaction.
        *   Agent ID.
        *   Command Sent (e.g., `@coderabbitai review`).
        *   Outcome (e.g., "Command Generated", "Rate Limited", "Executed Successfully").
        *   (Optional) Link to the comment/PR if available.
    *   **Modify CRQ Update Logic:**
        *   After a command is generated (and assuming it will be executed), the `crq_table_generator` will read the target CRQ file.
        *   It will append the formatted receipt to the CRQ file.
        *   It will then write the updated content back to the CRQ file. This will require using the `write_file` tool.

**Justification/Impact:**
This enhancement introduces a persistent, dynamic state management layer to our system, allowing for more intelligent and self-aware agent interactions. It will prevent hitting API rate limits, provide a clear audit trail of agent interactions, and enable more sophisticated decision-making based on the history of communication.