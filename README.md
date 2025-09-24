# ai-ml-zk-ops

This repository contains operational scripts and configurations for AI/ML/ZK projects, leveraging Nix for a reproducible and hermetic development environment.

## Nix-powered Development Workflow

This project utilizes Nix flakes to ensure a consistent and reproducible development environment across all contributors.

### Prerequisites

1.  **Install Nix:** If you don't have Nix installed, follow the official Nix installation guide. Ensure you enable Nix flakes.
    ```bash
    # Example for multi-user installation (recommended)
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    ```
    After installation, ensure your shell is configured to use Nix. You might need to restart your terminal or source the Nix profile.

2.  **Enable Flakes and Nix-Command:** Add the following to your `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`:
    ```
    experimental-features = nix-command flakes
    ```

### Getting Started

1.  **Clone the Repository:**
    ```bash
    git clone <repository-url>
    cd ai-ml-zk-ops
    ```

2.  **Enter the Development Shell:**
    To enter a development shell with all necessary tools and dependencies, run:
    ```bash
    nix develop
    ```
    This will build and activate a shell environment defined in `flake.nix`.

### Running Tests and Committing Changes

The `run_workflow.sh` script automates the process of committing your changes and running tests within the Nix environment. This ensures that all tests are executed against the committed code in a reproducible manner.

1.  **Prepare your Commit Message:**
    Write your commit message in `context/commit_message.txt`.

2.  **Execute the Workflow:**
    ```bash
    ./run_workflow.sh
    ```
    This script will:
    *   Read the commit message from `context/commit_message.txt`.
    *   Commit all current changes to Git.
    *   Execute the Nix flake's test check, which in turn runs `test.sh` (which calls `build.sh` and logs its output).

    You can find the test logs in the Nix store output (e.g., `result/test_output.log`).

## Project Structure

*   `flake.nix`: Defines the Nix flake for the project, including development shell, packages, and checks.
*   `scripts/`: Contains various automation scripts.
*   `context/commit_message.txt`: Used by `run_workflow.sh` to get the commit message.
*   `test.sh`: The main test script executed by the Nix flake check.
*   `build.sh`: Build script.

## Contributing

Please refer to the `docs/` directory for detailed CRQs (Change Request documents), SOPs (Standard Operating Procedures), and tutorials.