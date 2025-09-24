# SOP: Commit Analysis Review and Summarization

## 1. Purpose
This SOP outlines the procedure for reviewing commit analyses, identifying unanalyzed commits, performing analysis, and summarizing findings. It also covers the process of "lattice folding" to group and categorize commit insights.

## 2. Scope
This SOP applies to all commit analysis tasks within the project, specifically those located in `tasks/commit_analysis/`.

## 3. Prerequisites
*   Access to the project repository.
*   Familiarity with Git concepts (commits, diffs).
*   Understanding of the project's overall goals and technical stack (Nix, LLM, etc.).

## 4. Procedure

### 4.1. Identify Commits Requiring Analysis
1.  **List all `analysis_summary.md` files:**
    Use the command `ls -latr <project_root>/tasks/commit_analysis/*/analysis_summary.md` to list all existing analysis summary files, sorted by modification time. This helps identify recently modified or created files.
2.  **Check for missing or empty summaries:**
    For each commit hash directory in `tasks/commit_analysis/`, check if `analysis_summary.md` exists and if its content is empty or contains only a placeholder.
    *   If `analysis_summary.md` is missing or empty, the commit requires analysis.
    *   If `analysis_summary.md` contains a placeholder like "Commit Analysis: <hash>", it also requires full analysis.

### 4.2. Analyze Individual Commits
For each commit identified in Step 4.1:
1.  **Locate Commit Files:** Navigate to the commit's directory: `<project_root>/tasks/commit_analysis/<commit_hash>/`.
2.  **Read Commit Message:** Read the content of `commit_message.txt` to understand the stated purpose of the commit.
3.  **Review Diff Stats:** Read `diff_stats.txt` for a high-level overview of changes (files added, modified, deleted, lines inserted/deleted).
4.  **Review Full Diff (with size check):**
    *   Determine the size (number of lines) of `full_diff.txt`.
    *   **If `full_diff.txt` is larger than 10,000 lines:** Do NOT read the entire file. Note that the diff is too large for a detailed line-by-line analysis. Focus on the `commit_message.txt` and `diff_stats.txt` for a high-level summary. Consider suggesting breaking up large diffs in future commits or focusing on smaller, more manageable diffs for analysis.
    *   **If `full_diff.txt` is 10,000 lines or less:** Read the content of `full_diff.txt` to understand the specific code changes.
5.  **Synthesize Analysis:** Based on the commit message, diff stats, and (if applicable) the full diff, synthesize the following:
    *   **Key Changes and Purpose:** A bulleted list describing the main modifications and their intent.
    *   **Overall Impact:** A concise summary of how this commit affects the project (e.g., improves stability, adds new features, refactors code, enhances documentation).

### 4.3. Fill Out `analysis_summary.md`
1.  **Create/Update File:** Open or create the `analysis_summary.md` file within the commit's directory: `<project_root>/tasks/commit_analysis/<commit_hash>/analysis_summary.md`.
2.  **Populate Content:** Write the synthesized analysis into the file using the following template:

    ```markdown
    # Analysis of Commit <commit_hash>

    **Commit Message:** `<commit_message_from_file>`

    **Key Changes and Purpose:**

    1.  <Key Change 1>
    2.  <Key Change 2>
        *   <Sub-point>
    ...

    **Overall Impact:**

    <Concise summary of overall impact.>
    ```

### 4.4. Summarize and Lattice-Fold Commit Analyses
1.  **Gather All Analyses:** Collect the content of all `analysis_summary.md` files across `tasks/commit_analysis/`.
2.  **Extract Key Information:** For each analysis, extract the commit hash, commit message, key changes, and overall impact.
3.  **Categorize Commits:** Group commits into major themes (e.g., Nix Ecosystem, LLM Knowledge, Automation, Governance, Quality) based on their content.
4.  **Apply Lattice Folding:** Organize the categorized commits hierarchically using the ZOS primes `[2, 3, 5, 7, 11, 13, 17, 19]` to define the number of items at each level of the hierarchy. Assign recursive addresses to each group.
5.  **Generate Structured Output:** Create a structured file (e.g., YAML) containing the lattice-folded summary, including themes, sub-themes, recursive addresses, and summarized commit information.

## 5. Tools Used
*   `ls` (shell command)
*   `read_file` (Gemini tool)
*   `read_many_files` (Gemini tool)
*   `write_file` (Gemini tool)
*   `replace` (Gemini tool)
*   `glob` (Gemini tool)
*   Regular expressions (for parsing)

## 6. Best Practices
*   Be concise and clear in summaries.
*   Prioritize understanding the *why* behind changes.
*   Cross-reference related CRQs or SOPs where applicable.
*   If a diff is too large, acknowledge it and focus on high-level impact.
