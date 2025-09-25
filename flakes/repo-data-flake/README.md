# Project Overview

This directory contains a `Makefile` that automates various operations on Nix flakes and shell scripts within the project.

## Makefile

The `Makefile` provides the following functionalities:

*   **`all`**: The default target. It builds test results for all `flake.nix` files and runs `shellcheck` on all `.sh` scripts.
*   **`clean`**: Removes all generated `.test-result.json` and `.shellcheck-result.txt` files.

### Dynamic Target Generation

The `Makefile` dynamically discovers `flake.nix` files and `.sh` scripts in the current directory and its subdirectories. For each discovered file, it creates a corresponding target:

*   For `flake.nix` files: A `.test-result.json` file is generated, containing the JSON output of `nix build` for that flake.
*   For `.sh` scripts: A `.shellcheck-result.txt` file is generated, containing the output of `shellcheck` for that script.

## Scripts

### `scripts/build_test_result.sh`

This script is responsible for building a Nix flake and capturing its JSON output. It takes two arguments:

1.  The path to the `flake.nix` file.
2.  The path to the output `.test-result.json` file.

Usage:
`./scripts/build_test_result.sh <flake.nix_file> <output.test-result.json_file>`

### `scripts/run_shellcheck.sh`

This script runs `shellcheck` on a given shell script and redirects its output to a specified file. It takes two arguments:

1.  The path to the `.sh` file.
2.  The path to the output `.shellcheck-result.txt` file.

Usage:
`./scripts/run_shellcheck.sh <shell_script_file> <output.shellcheck-result.txt_file>`
