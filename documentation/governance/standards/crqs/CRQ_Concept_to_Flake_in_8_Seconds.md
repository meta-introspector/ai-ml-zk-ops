# CRQ: Concept to Flake in 8 Seconds - Refactoring `flake.nix`

## 1. Problem Statement

The current `flake.nix` is monolithic and complex, hindering maintainability, testability, and composability. Its size makes it difficult to manage and understand, especially in the context of dynamic flake generation and meta-programming goals.

## 2. Proposed Solution

Refactor the existing `flake.nix` into 7 smaller, specialized, and composable flakes. This will improve modularity, enable easier testing of individual components, and facilitate dynamic flake generation.

## 3. Rules Governing Implementation

To ensure a robust and maintainable solution, the following rules will be strictly adhered to:
1.  **Nix commands only call scripts:** Direct complex Nix expressions should be minimized in `flake.nix` files. Instead, Nix should invoke shell scripts for complex logic.
2.  **All complex expressions are in scripts:** Any logic beyond simple attribute sets or basic function calls will be encapsulated within shell scripts.
3.  **All scripts are tested:** Every script invoked by Nix flakes will have corresponding unit or integration tests to ensure correctness and reliability.

## 4. Goals

The refactoring aims to achieve the following:
1.  **Virtual Flakes per Term:** Each significant "term" or concept within the project should ideally be represented as a virtual flake, dynamically generated.
2.  **Awk as a Flake:** The functionality for running `awk` commands (currently part of a large `test flake.nix`) will be isolated into its own dedicated flake.
3.  **Composability:** The smaller flakes should be easily composable to build larger, more complex functionalities.
4.  **Dynamic Flake Generation:** The `files.txt` will be used as input for Nix meta-programming and lifting to dynamically generate a set of virtual `flake.nix` files.

## 5. High-Level Refactoring Plan

The current `flake.nix` already aggregates 7 sub-flakes. The refactoring will focus on transforming the main `flake.nix` into a dynamic flake composer, rather than explicitly listing each sub-flake. This will involve:

-   **Dynamic Discovery and Composition:** The main `flake.nix` will dynamically discover and compose flakes, potentially based on directory structure or a configuration file.
-   **Integration of Existing Sub-flakes:** The existing 7 sub-flakes (`awk-runner-flake`, `default-package-flake`, `dev-shell-flake`, `flake-utils-wrapper`, `nixpkgs-pinned`, `repo-data-flake`, `repo-packages-flake`) will be integrated into this dynamic composition mechanism.
-   **Virtual Flake Generation:** Implement a mechanism to generate "virtual flakes" for each term, possibly driven by `files.txt` and Nix meta-programming.
-   **Script-based Logic:** Ensure that complex logic for flake generation and composition adheres to the rule of being encapsulated in tested scripts.

## 6. Initial Steps

1.  **Analyze Current `flake.nix` (Completed):** Understand the existing structure and how the 7 sub-flakes are currently integrated.
2.  **Define Dynamic Composition Strategy:** Determine how the main `flake.nix` will dynamically discover and compose flakes (e.g., using `builtins.readDir` or a custom script).
3.  **Develop Virtual Flake Generation Logic:** Create Nix meta-programming constructs and associated scripts to generate virtual flakes based on `files.txt` and other "terms".
4.  **Refactor Main `flake.nix`:** Modify the main `flake.nix` to implement the dynamic composition and virtual flake generation.
5.  **Migrate Explicit Inputs to Dynamic:** Replace explicit `path:` inputs for the 7 sub-flakes with dynamic discovery.
6.  **Implement and Test Scripts:** Develop and thoroughly test all new scripts used for dynamic composition and virtual flake generation.
7.  **Verify Flake Functionality:** Ensure that all existing functionalities (packages, devShells, checks) continue to work correctly after refactoring.
