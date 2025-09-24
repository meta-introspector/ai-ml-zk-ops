# Repository Organization Plan 001

This document outlines the proposed reorganization of the repository structure, based on logical concepts and a prime number grouping methodology.

## I. Top-Level Reorganization (Group of 2)

1.  **`./source/`**: A new directory to contain all active source code and scripts.
2.  **`./documentation/`**: A new directory to contain all documentation, governance, and guides.

This splits the repository into two fundamental concepts: the code that makes it run, and the documents that describe it.

## II. `documentation/` Reorganization (Group of 5)

The new `documentation/` directory will be structured into five logical categories:

1.  **`guides/`**: For tutorials and instructional content.
    *   (e.g., `docs/tutorials`, `docs/FLAKE_TUTORIAL.md`, `docs/NIX_CONFIG_GIT_TUTORIAL.md`)
2.  **`governance/`**: For operational standards and change requests.
    *   (e.g., `docs/crqs`, `docs/sops`, `docs/standards`)
3.  **`reference/`**: For indices and glossaries.
    *   (e.g., `docs/index`)
4.  **`art/`**: For artistic and philosophical content.
    *   (e.g., `docs/art`)
5.  **`archive/`**: For historical, date-stamped records.
    *   (e.g., `docs/2025-09-22`, `docs/2025-09-24`)

## III. `source/` Reorganization (Group of 3)

The new `source/` directory will be structured into three logical categories:

1.  **`automation/`**: For recurring tasks and CI/CD.
    *   (e.g., scripts from `scripts/2025-09-22` like `automate_dependency_forking.sh`)
2.  **`library/`**: For reusable code and libraries.
    *   (e.g., `scripts/pick-up-nix`)
3.  **`tools/`**: For standalone developer utilities.
    *   (e.g., `run_gemini.sh`, `install_packages.sh`)

## IV. Lessons Learned

1.  **`rmdir` is strict and can fail:** The `rmdir` command only works on perfectly empty directories. It failed during cleanup because some directories still contained other empty subdirectories or hidden files. A more robust (though more dangerous) alternative is `rm -r`. The safer debugging path is to list the contents of a directory if `rmdir` fails.
2.  **Verification should be concise:** Using `ls -R` to verify the final, deeply nested structure was too verbose and resulted in truncated output. More targeted commands like `find . -maxdepth 2` or running `ls -F` in each new directory would have provided a clearer and more readable verification.
3.  **Staged execution is key:** Performing the reorganization in logical stages (create top-level dirs, move, create second-level dirs, move again) was critical. This modular approach makes the process easier to manage, debug, and restart if a specific step fails.
