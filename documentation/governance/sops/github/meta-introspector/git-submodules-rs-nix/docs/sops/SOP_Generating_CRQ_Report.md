# SOP: Generating the CRQ Report

## Purpose

This Standard Operating Procedure (SOP) outlines the steps for generating a summary report of all Change Request/Question (CRQ) documents, grouped by their suggested next step. This report provides an overview of the project's current focus areas based on the automated classification of CRQs.

## Prerequisites

*   The `crq_table_generator` Rust project must be built in release mode. Ensure the executable is available at `./target/release/crq_table_generator` relative to the project root.
*   The `generate_crq_summary.sh` script must be available in the `tools/` directory and have execute permissions.
*   CRQ documents must be located in the `docs/crq_standardized/` directory and follow the standard CRQ format.

## Procedure

1.  **Navigate to the Project Root:**
    Open your terminal and navigate to the root directory of the `meta-introspector/submodules` project.

    ```bash
    cd /path/to/meta-introspector/submodules
    ```

2.  **Run the Report Generation Script:**
    Execute the `generate_crq_summary.sh` script. By default, this will print the detailed CRQ report to your console.

    ```bash
    ./tools/generate_crq_summary.sh
    ```

    **Generating Commands for CoderabbitAI Review Requests:**
    To generate a shell script containing `gh pr comment` commands for CRQs classified as "Review Skipped (No Meaningful Response)", use the `--generate-commands` and `--output-script` options with the `crq_table_generator` directly:

    ```bash
    ./target/release/crq_table_generator --generate-commands --output-script nextstep.sh \
        --crq-dir /data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules/docs/crq_standardized \
        --task-file /data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules/task.md
    ```
    Remember to review the generated `nextstep.sh` script before running it.

3.  **Review the Output:**
    The report now provides a detailed table with the following columns and refined classifications:

    *   **CRQ Number:** The unique identifier for the CRQ.
    *   **Count Responses:** The number of communication messages found from CoderabbitAI for this CRQ.
    *   **Total Size (bytes):** The combined byte size of all CoderabbitAI communication messages for this CRQ.
    *   **Skipped Review:** "Yes" if CoderabbitAI explicitly indicated a skipped review in its communications, "No" otherwise.
    *   **Suggested Next Step:** The classification determined by the state machine logic, indicating the recommended next action. Possible states include:
        *   **Review Provided:** CoderabbitAI has successfully provided a meaningful review.
        *   **Review Skipped (No Meaningful Response):** CoderabbitAI skipped the review, and no subsequent meaningful response was found.
        *   **Review Needed from CoderabbitAI:** Smaller CRQs that haven't been reviewed yet by CoderabbitAI.
        *   **Respond To / Our Turn:** CRQs requiring human attention, decision-making, or strategic input.
        *   **Develop/Implement:** Direct development or implementation tasks.
        *   **Document:** Documentation tasks.
        *   **Refactor:** Refactoring or code improvement tasks.
        *   **Unknown:** Classification could not be determined.

## Troubleshooting

*   **"Error: crq_table_generator executable not found:"**: Ensure you have built the `crq_table_generator` Rust project in release mode. Navigate to the project root and run `cargo build --release -p crq_table_generator`.
*   **"Error reading CRQ directory..."**: Ensure the `docs/crq_standardized/` directory exists and contains readable CRQ files.
*   **"Error reading task.md file..."**: Ensure `task.md` exists and is readable.

## Related Documents

*   [SOP_Using_CRQ_Classifier.md](SOP_Using_CRQ_Classifier.md)
*   [SOP_Creating_New_CRQ.md](SOP_Creating_New_CRQ.md)
*   [SOP_CRQ_State_Classification.md](SOP_CRQ_State_Classification.md)
