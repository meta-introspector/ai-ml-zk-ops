# SOP: Recursive Tuple Branch Management

## Objective
To outline the procedure for setting up, managing, and working with a "recursive tuple branch" structure within the repository.

## Scope
This SOP applies to developers working on projects utilizing the "recursive tuple branch" strategy for concurrent branch management.

## Prerequisites
*   Git installed and configured.
*   Understanding of Git submodules.
*   Familiarity with the `meta-introspector` repository structure.

## Procedure:

### 1. Creating a New Tuple Branch:
*   Checkout `main`: `git checkout main`
*   Create a new tuple branch: `git checkout -b feature/my-new-tuple-branch` (or similar naming convention).
*   Create the `self/branches/` directory: `mkdir -p self/branches`
*   For each branch you want to include in this tuple:
    *   Add the current repository as a submodule, pointing to the desired branch:
        ```bash
        git submodule add -b <branch_name> <repository_url> self/branches/<branch_name_alias>
        ```
        *   Replace `<branch_name>` with the actual branch name (e.g., `feature/my-feature-A`, `main`).
        *   Replace `<repository_url>` with the URL of the current repository (e.g., `https://github.com/meta-introspector/git-submodules-rs-nix.git`).
        *   Replace `<branch_name_alias>` with a short, descriptive name for the submodule directory (e.g., `feature-A`, `main-dev`).
    *   Example: `git submodule add -b feature/my-feature-A https://github.com/meta-introspector/git-submodules-rs-nix.git self/branches/feature-A`
*   Commit the changes: `git add .gitmodules self/branches/` and `git commit -m "feat: Add initial tuple branches"`
*   Push the new tuple branch: `git push origin feature/my-new-tuple-branch`

### 2. Working with an Existing Tuple Branch:
*   Checkout the tuple branch: `git checkout feature/existing-tuple-branch`
*   Initialize and update submodules: `git submodule update --init --recursive`
*   Navigate into the submodule directories (e.g., `cd self/branches/feature-A`) to work on those specific branches.

### 3. Updating Submodules within a Tuple Branch:
*   To pull latest changes for all submodules: `git submodule update --remote --merge` (or `--rebase` if preferred).
*   To update a specific submodule: `git submodule update --remote --merge self/branches/feature-A`
*   Commit the submodule updates in the parent repository.

### 4. Adding/Removing Branches from a Tuple Branch:
*   **Add:** Follow step 1.d for adding new submodules.
*   **Remove:**
    *   `git submodule deinit -f self/branches/<branch_name_alias>`
    *   `rm -rf .git/modules/self/branches/<branch_name_alias>`
    *   `git rm self/branches/<branch_name_alias>`
    *   Commit the changes.

### 5. Important Considerations:
*   **Circular Dependencies:** Be extremely cautious of creating circular dependencies where submodules directly or indirectly depend on the parent repository in a way that breaks Git's ability to resolve history.
*   **History Management:** Rebase operations on the parent repository can be complex and may require careful handling of submodule commits.
*   **Tooling:** Be aware that some Git GUIs or CI/CD tools may not fully support this advanced submodule setup. Custom scripting might be necessary.
*   **Performance:** A large number of submodules can impact Git operation performance.
