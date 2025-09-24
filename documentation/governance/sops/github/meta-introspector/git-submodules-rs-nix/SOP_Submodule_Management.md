# Standard Operating Procedure (SOP) for Submodule Management

This document outlines the purpose, usage, and evaluation of the Git submodule management tools used in this project: `gitoxide`, `submod`, and `magoo`.

## 1. gitoxide

### Purpose
`gitoxide` is a robust, pure-Rust implementation of Git functionalities. It aims for correctness, performance, and a pleasant developer experience, serving as a foundational library for Git operations within Rust applications.

### Evaluation for the Project
`gitoxide` is a core component for this project, providing essential Git functionalities in Rust. Its focus on correctness and performance makes it highly relevant for any Git-related operations, such as cloning, fetching, status checks, and object manipulation. It serves as a low-level building block that other tools or custom logic can leverage.

### When to Use
*   When developing new Rust features that require direct interaction with Git repositories (e.g., programmatic cloning, fetching, reading/writing Git objects, managing references, checking status).
*   When performance and correctness of Git operations are critical within a Rust application.
*   As a foundational library for building higher-level Git tools or custom automation in Rust.

### How to Use
1.  **As a Rust library:** Add `gix` as a dependency in your `Cargo.toml`. Utilize its API for programmatic Git interactions. Refer to the `gix` crate documentation on `docs.rs` for detailed API usage.
2.  **As command-line tools (`gix` and `ein`):** These binaries are primarily for development and testing the API. **Do not rely on them in scripts** due to their unstable nature. They can be used for manual inspection or debugging of Git repositories.

### Integration with Nix
The `flake.nix` includes `gitoxide` as a submodule and defines a check for it, ensuring its build and test integrity within the Nix environment. This allows for reproducible builds and testing of `gitoxide` as part of the overall project.

## 2. submod

### Purpose
`submod` is a lightweight, fast CLI tool designed to simplify Git submodule management. It offers advanced features like TOML-based configuration and sparse checkout support, built on top of `gitoxide` and `git2` for performance and reliability. It aims to streamline complex submodule workflows and reduce barriers to contribution.

### Evaluation for the Project
`submod` is highly relevant to this project, which is focused on submodule management. It directly addresses the challenges of managing Git submodules, especially with sparse checkouts and consistent configuration. Its TOML-based configuration makes it ideal for automated project setup and maintaining a consistent submodule state across development environments and CI/CD pipelines within a Nix environment.

### When to Use
*   When your project heavily utilizes Git submodules and requires a more robust and configurable management solution than native `git submodule` commands.
*   When you need to efficiently manage large submodules by only checking out specific parts (sparse checkout) to reduce repository size and clone times.
*   To automate submodule initialization, updates, and status checks as part of your project's setup scripts or CI/CD workflows.

### How to Use
1.  **Installation:** Install `submod` using `cargo install submod` or `mise use cargo:submod@latest`.
2.  **Configuration (`submod.toml`):** Create a `submod.toml` file in your repository root to define your submodules, their paths, URLs, and sparse checkout configurations. You can set global defaults and override them per submodule.
3.  **Key Commands:**
    *   `submod init`: Initialize missing submodules based on `submod.toml`.
    *   `submod update`: Update all submodules to their latest commits.
    *   `submod check`: Check the status of all configured submodules.
    *   `submod add`: Add a new submodule to your configuration and repository.
    *   `submod reset`: Hard reset submodules (stash changes, reset --hard, clean).
    *   `submod sync`: Run a complete sync (check + init + update).

### Integration with Nix
The `flake.nix` includes `submod` as a submodule and defines a check for it, ensuring its build and test integrity within the Nix environment. `submod`'s explicit configuration makes it well-suited for orchestration within Nix derivations for automated project setup.

## 3. magoo

### Purpose
`magoo` is a CLI tool designed to simplify Git submodule management by acting as a wrapper around standard `git submodule` commands. It aims to abstract away some complexities and provide a more user-friendly experience for common submodule operations.

### Evaluation for the Project
`magoo` is relevant for Git submodule management, but its approach differs from `submod`. `magoo` focuses on simplifying existing `git submodule` commands without requiring a separate configuration file. Its philosophy of "not liking pipelines" suggests it's more suitable for interactive, local development workflows where quick and easy submodule management is prioritized over extensive configuration or automation within CI/CD. For automated project setup in a Nix environment, `submod`'s explicit configuration is generally more advantageous.

### When to Use
*   For interactive, local development and quick, ad-hoc management of Git submodules.
*   When you prefer a tool that works directly with the Git repository's existing `.gitmodules` configuration without requiring additional configuration files like `submod.toml`.
*   To easily update, initialize, add, or remove submodules during day-to-day development where a simple wrapper around `git` commands is sufficient.

### How to Use
1.  **Installation:** Install `magoo` using `cargo install magoo`.
2.  **Prerequisites:** Ensure `git` is installed on your system, as `magoo` runs `git` commands as sub-processes.
3.  **Key Commands:**
    *   `magoo install [URL] [PATH]`: Add a new submodule or initialize/pull existing submodules.
    *   `magoo status [--long] [--fix]`: Show submodule status and optionally fix inconsistencies.
    *   `magoo update [NAME]`: Update all or specific submodules to their tracked branches.
    *   `magoo remove NAME`: Remove a submodule and all its traces.
    *   `magoo --allow-unsupported <command>`: Allow `magoo` to run with unsupported `git` versions.

### Integration with Nix
The `flake.nix` includes `magoo` as a submodule and defines a check for it, ensuring its build and test integrity within the Nix environment. However, due to `magoo`'s design philosophy, it may not be the primary tool for highly automated, reproducible project setup within Nix derivations, where `submod`'s explicit configuration is often preferred.
