**Standard Operating Procedure: Documenting Outstanding Changes and Managing Change Requests (CRQs)**

**1. Purpose:**
This SOP outlines the process for identifying, documenting, and linking outstanding code changes to existing Change Requests (CRQs) or creating new CRQs when necessary. This ensures all modifications are properly tracked, reviewed, and aligned with project goals.

**2. Scope:**
This procedure applies to all code changes, features, bug fixes, or refactorings that are not yet associated with an approved CRQ.

**3. Definitions:**
*   **Outstanding Change:** Any modification to the codebase that has been implemented or is in progress but lacks a formal Change Request (CRQ).
*   **CRQ (Change Request):** A formal document or entry in a tracking system that describes a proposed change, its rationale, scope, and impact.

**4. Responsibilities:**
*   **Developer/Engineer:** Responsible for identifying outstanding changes, searching for existing CRQs, and initiating new CRQs.
*   **Project Lead/Manager:** Responsible for reviewing and approving new CRQs.

**5. Procedure:**

**5.1. Identify Outstanding Changes:**
    a.  Regularly review your local working directory for uncommitted or un-pushed changes.
    b.  Use `git status` to identify modified, added, or deleted files.
    c.  Use `git diff` to review the specifics of the changes.
    d.  For larger, uncommitted work, consider using `git add -p` and `git commit -v` to review changes in chunks.

**5.2. Search for Existing CRQs:**
    a.  Before creating a new CRQ, attempt to find an existing one that covers the outstanding change.
    b.  **Method 1: Search by Commit Message/Branch Name:**
        *   If the change is already committed, examine commit messages for CRQ identifiers (e.g., "CRQ-123: Implement feature X").
        *   Check branch names for CRQ references (e.g., `feature/CRQ-456-new-dashboard`).
    c.  **Method 2: Search the CRQ Tracking System:**
        *   Access the project's CRQ tracking system (e.g., Jira, GitHub Issues, a custom markdown system).
        *   Search using keywords related to the change (e.g., feature name, bug description, affected module).
        *   Filter by status (e.g., "Open," "In Progress," "To Do") to find relevant active CRQs.

**5.3. Create a New CRQ (If None Found):**
    a.  If no existing CRQ adequately covers the outstanding change, a new one must be created.
    b.  **Gather Information for the New CRQ:**
        *   **Title:** A concise, descriptive summary of the change (e.g., "Implement User Profile Editing," "Fix Login Bug on Mobile").
        *   **Description:** Detail the problem being solved or the feature being added. Include:
            *   **Problem/Opportunity:** What issue does this change address, or what new capability does it provide?
            *   **Proposed Solution:** Briefly describe how the change will be implemented.
            *   **Impact:** What areas of the system or user experience will be affected?
            *   **Acceptance Criteria:** How will successful implementation be verified?
        *   **Affected Components:** List files, modules, or services that will be modified.
        *   **Priority:** Assign a priority level (e.g., High, Medium, Low).
        *   **Effort Estimate:** Provide a rough estimate of the work involved.
        *   **Link to Code (Optional, if already started):** If code exists, provide a link to the branch or commit.
    c.  **Use the `new_crq.sh` script (if applicable):**
        *   Navigate to the `tools/` directory.
        *   Execute `./new_crq.sh` and follow the prompts to generate a new CRQ markdown file.
        *   Fill in the generated template with the gathered information.
    d.  **Submit for Review:**
        *   If using a formal tracking system, submit the new CRQ for review and approval by the Project Lead/Manager.
        *   If using markdown files, commit the new CRQ file to the appropriate repository and create a pull request for review.

**5.4. Link Outstanding Changes to CRQs:**
    a.  Once a CRQ is identified or created, ensure the outstanding changes are explicitly linked to it.
    b.  **For Commits:**
        *   Include the CRQ identifier in your commit messages (e.g., `git commit -m "CRQ-XXX: Fix bug in authentication module"`).
    c.  **For Branches:**
        *   Name your feature or bugfix branches with the CRQ identifier (e.g., `feature/CRQ-XXX-user-profile`).
    d.  **In the CRQ Tracking System:**
        *   Update the CRQ entry to include links to relevant pull requests, branches, or specific commits.

**6. Verification:**
*   Periodically review the CRQ tracking system and code repository to ensure all active changes have corresponding CRQs.
*   Conduct regular code reviews to catch any un-tracked changes.

**7. Related Documents:**
*   `new_crq.sh` script documentation
*   Project's Git Branching Strategy
*   CRQ Tracking System Guidelines
