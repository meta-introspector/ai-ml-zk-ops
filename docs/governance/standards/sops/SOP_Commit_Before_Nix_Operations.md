# SOP: Commit Before Nix Operations

## 1. Purpose

This Standard Operating Procedure (SOP) outlines the critical requirement to commit all new or modified files to Git *before* initiating any Nix-related operations (e.g., `nix build`, `nix develop`, `nix flake check`, `nix run`). This ensures that Nix operates on a stable, version-controlled state of the project, preventing unexpected behavior, ensuring reproducibility, and facilitating debugging.

## 2. Scope

This SOP applies to all developers, contributors, and automated systems interacting with Nix within this project, especially when new files are introduced or existing files are modified.

## 3. Policy

All new files, or changes to existing files, that are relevant to the Nix build or development environment *must* be committed to the Git repository before any Nix command is executed that would interact with these files. This includes, but is not limited to:

*   New `flake.nix` or `flake.lock` files.
*   New `.nix` files (modules, packages, overlays).
*   New source code files that are part of a Nix derivation.
*   Configuration files or data files that are read by Nix expressions.
*   Any files that are part of a Nix input or output.

## 4. Procedure

1.  **Stage Changes**: After creating new files or modifying existing ones, stage them for commit using `git add <file(s)>`.
2.  **Commit Changes**: Commit the staged changes with a descriptive commit message using `git commit -m "Your descriptive commit message"`.
3.  **Verify Commit**: Ensure the changes are committed by checking `git status`. The working directory should be clean, or only contain untracked files not relevant to the current Nix operation.
4.  **Execute Nix Command**: Only after the relevant changes are committed, proceed with the desired Nix operation (e.g., `nix build`, `nix develop`, `nix flake check`).

## 5. Rationale

*   **Reproducibility**: Nix relies on a consistent input set. Uncommitted changes can lead to non-reproducible builds or development environments, as Nix might not capture the exact state of the working directory.
*   **Debugging**: When issues arise, a committed state allows for easier debugging and rollback to a known good configuration. It isolates changes and prevents confusion caused by transient, uncommitted modifications.
*   **Flake Purity**: Nix flakes aim for purity and hermeticity. Operating on uncommitted files can violate this principle, leading to unexpected dependencies or build failures.
*   **Collaboration**: In a collaborative environment, uncommitted changes make it difficult for others to reproduce your work or integrate their changes.

## 6. Enforcement

Failure to adhere to this SOP may result in build failures, inconsistent development environments, and difficulties in troubleshooting. Automated checks (e.g., CI/CD pipelines) may be implemented to enforce this policy.
