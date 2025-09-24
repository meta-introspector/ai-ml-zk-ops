# Standard Operating Procedure (SOP) for Agent Recovery

## 1. Introduction

This SOP outlines the procedure for the agent to follow when encountering errors or unexpected operational roadblocks. The goal is to systematically identify the issue, formulate a solution, and recover gracefully, ensuring continuous progress and learning from the experience.

## 2. Recovery Procedure

### 2.1 Observe and Identify the Error
*   **Action**: Immediately halt current operation upon receiving an error message or unexpected output.
*   **Focus**: Read the error message carefully. Identify keywords, error codes, and the specific tool or command that failed.
*   **Input**: Error messages, tool output, system logs.

### 2.2 Orient and Analyze the Cause
*   **Action**: Analyze the identified error in the context of the current task and the agent's operational environment.
*   **Activities**:
    *   **Consult Internal Knowledge**: Access memory for similar past errors, known tool limitations, or relevant operational guidelines (e.g., `.git_commit_message.txt` usage).
    *   **Review Tool Documentation**: If the error points to a specific tool, review its documentation for common issues, usage patterns, or constraints.
    *   **Examine Code/Configuration**: If the error is related to code modification or configuration, review the recent changes for syntax errors, logical flaws, or unmet dependencies.
    *   **Formulate Hypotheses**: Develop potential reasons for the error and possible solutions.
*   **Tools/Inputs**: Internal memory, tool documentation, relevant code/configuration files.

### 2.3 Decide on a Recovery Strategy
*   **Action**: Based on the analysis, select the most appropriate recovery strategy.
*   **Considerations**:
    *   **Direct Fix**: If the cause is clear and simple (e.g., a typo, incorrect parameter), apply a direct fix.
    *   **Alternative Approach**: If the current method is problematic (e.g., tool limitation), devise an alternative approach that achieves the same goal.
    *   **Information Gathering**: If the cause is unclear, plan further diagnostic steps (e.g., running a simpler version of the command, inspecting intermediate states).
    *   **User Clarification**: If the path forward is ambiguous or requires a decision beyond the agent's scope, seek clarification from the user.
*   **Output**: A clear, actionable plan for recovery.

### 2.4 Act on the Recovery Strategy
*   **Action**: Execute the chosen recovery strategy.
*   **Activities**:
    *   Implement code changes.
    *   Run diagnostic commands.
    *   Attempt the alternative approach.
    *   Communicate with the user if clarification is needed.
*   **Tools**: `run_shell_command`, `write_file`, `replace`, `read_file`, `list_directory`, `search_file_content`, `glob`, `save_memory`, `google_web_search`.

### 2.5 Verify Recovery and Learn
*   **Action**: Confirm that the error is resolved and the operation can proceed.
*   **Activities**:
    *   Re-run the failed command or the new approach.
    *   Check for expected output and absence of errors.
    *   **Document Learning**: If a new pattern or solution is discovered, consider documenting it in an SOP or story document for future reference.
*   **Output**: Successful completion of the task or a clear path to the next step.

## 3. Best Practices for Recovery
*   **Stay Calm**: Maintain a systematic approach even under pressure.
*   **Iterate**: Recovery may require multiple cycles of Observe-Orient-Decide-Act.
*   **Communicate**: Keep the user informed, especially if delays or complex issues arise.
*   **Learn from Every Error**: Each error is an opportunity to refine the agent's knowledge and operational resilience.