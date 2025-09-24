# Standard Operating Procedure (SOP) for Creating Documentation

## 1. Introduction

This SOP outlines the process for creating effective documentation, specifically Standard Operating Procedures (SOPs), by leveraging Git history and an iterative development approach. Good documentation is crucial for maintaining project clarity, onboarding new team members, and ensuring reproducibility.

## 2. Process for Creating SOPs from Git History

Creating SOPs from Git history involves extracting valuable insights from past operations, problems, and solutions. This process helps in formalizing knowledge and establishing best practices.

### 2.1 Review Git History

Start by examining the project's Git commit history to identify significant changes, bug fixes, feature additions, and problem-solving efforts.

**Tool**: `git log`

**Command**: `git log --pretty=fuller --stat -<number_of_commits>`

*   `--pretty=fuller`: Provides detailed information including author, committer, and their dates.
*   `--stat`: Shows file changes (insertions, deletions) for each commit.
*   `-<number_of_commits>`: Limits the output to the specified number of most recent commits.

**What to Look For**:
*   **Commit Messages**: Pay close attention to commit messages, especially those following conventional commits (e.g., `fix:`, `feat:`, `build:`, `docs:`), as they often summarize the intent and outcome of the changes.
*   **Files Changed**: Identify which files were modified, added, or deleted. This helps in understanding the scope of the operation.
*   **Problem/Solution Patterns**: Look for commits that address specific problems or implement solutions. These are prime candidates for SOP topics.

### 2.2 Extract Operations and Insights

For each relevant commit, extract the core operation performed, the context (why it was done), the solution implemented, and any challenges encountered.

**Example Insights from a Commit**:
*   **Operation**: Setting `CARGO_HOME` for Rust builds in Nix.
*   **Problem**: Build failures due to `CARGO_HOME` not being writable.
*   **Solution**: Explicitly setting `CARGO_HOME` to `$TMPDIR/.cargo`.
*   **Tool Used**: `flake.nix`, `pkgs.runCommand`.

### 2.3 Categorize and Summarize

Group similar operations or insights into logical categories. This helps in structuring the SOPs and ensuring comprehensive coverage of related topics.

**Example Categories**:
*   Nix Flake Debugging
*   Git Source Management
*   Project Setup Automation
*   Tool Usage Guidelines

### 2.4 Write SOP Documents

Based on the categorized insights, draft individual SOP documents. Each SOP should clearly define:

*   **Introduction**: Briefly explain the purpose and scope of the SOP.
*   **Problem/Context**: Describe the problem or scenario the SOP addresses.
*   **Solution/Procedure**: Detail the steps or configuration required to resolve the problem or perform the operation.
*   **Tools Used**: List the specific tools, commands, or code snippets involved.
*   **Best Practices**: Include any recommended practices or considerations.
*   **CRQ Linkage (Optional)**: If this SOP is a direct result of a CRQ or is closely related to one, consider referencing the relevant CRQ(s) for traceability and context.

### 2.5 Organize Documentation

Store the created SOPs in a dedicated, easily accessible directory within the project repository.

**Recommended Location**: `docs/sops/`

## 3. Iterative Development of Documentation

Documentation is not a one-time task but an ongoing process. Embrace an iterative approach:

*   **Start Small**: Begin by documenting the most critical or frequently encountered operations.
*   **Refine and Expand**: As the project evolves or new insights emerge, update existing SOPs and create new ones.
*   **Feedback Loop**: Encourage team members to provide feedback on the clarity, accuracy, and completeness of the documentation.
*   **Version Control**: Keep documentation under version control (e.g., Git) alongside the codebase to track changes and ensure consistency.

## 4. Best Practices for Documentation

*   **Clarity and Conciseness**: Write in clear, unambiguous language. Avoid jargon where possible, or explain it.
*   **Actionable Steps**: Provide step-by-step instructions for procedures.
*   **Examples**: Include code snippets or command examples to illustrate concepts.
*   **Maintainability**: Keep documents focused on single topics to make them easier to update.
*   **Accessibility**: Ensure documentation is easy to find and navigate.
*   **Review and Approval**: Establish a clear process for reviewing and approving SOPs to ensure accuracy, quality, and consensus among team members.

## 5. How This SOP Was Created

This SOP itself was created using the process described above. It involved reviewing the Git history of this project, identifying the steps taken to debug Nix flake issues, manage Git sources, and automate project setup. The challenges encountered during these operations (e.g., `pkg-config` errors, `git` repository recognition in Nix) directly informed the content of the related SOPs. The iterative nature of this documentation process allowed for continuous refinement and the inclusion of lessons learned during the project's development.
