# SOP: Diagnosing Nix Flake Build Failures

## 1. Purpose

This Standard Operating Procedure (SOP) provides a guide for diagnosing and troubleshooting common build failures encountered when working with Nix flakes. It is designed to assist users, especially those new to Nix, in understanding error messages, locating relevant logs, and applying effective debugging techniques to resolve issues.

## 2. Scope

This SOP applies to all Nix flake build and development environment failures within the project.

## 3. Understanding Nix Build Failures

When a Nix flake build fails, you will typically see an error message indicating that a "builder failed with exit code 1" (or similar). This means that a script or command executed within the Nix build environment terminated unsuccessfully.

## 4. Locating and Interpreting Logs

The key to diagnosing Nix build failures is to examine the detailed logs.

### 4.1. Initial Error Message

The console output of a failed Nix build will usually provide the "last few log lines" from the failing builder. These lines often contain crucial hints about the immediate cause of the failure.

### 4.2. Full Build Logs (`nix log`)

For a more comprehensive view, use the `nix log` command with the `.drv` path provided in the error message:

```bash
nix log /nix/store/<hash>-<derivation_name>.drv
```

*   **Note**: If `nix log` only shows the same few lines, it might mean the actual detailed output was redirected by a script *within* the derivation.

### 4.3. Script-Redirected Logs

If a script within the Nix derivation (e.g., `nix_test_runner.sh` calling `test.sh`) redirects its output to a specific file (e.g., `$out/test_output.log`), you will need to locate and inspect that file within the Nix store. The path to this log file will typically be mentioned in the `nix log` output or the initial error message.

```bash
cat /nix/store/<hash>-<output_name>/<log_file_name>
```

## 5. Common Issues and Solutions

### 5.1. "No such file or directory"

*   **Cause**: A script or command tried to access a file or directory that does not exist in the Nix build environment.
*   **Diagnosis**: Check the path mentioned in the error. Remember that Nix builds are hermetic; only files explicitly included in the `src` of a derivation are available.
*   **Solution**:
    *   Ensure all necessary files are included in the `src` of the derivation (e.g., `src = self;` for the entire flake).
    *   If a script creates directories (like `logs/`), ensure `mkdir -p` is called *within the script* before attempting to write to them. Nix's `src` does not copy `.gitignore`d directories.

### 5.2. "attribute 'currentSystem' missing"

*   **Cause**: `builtins.currentSystem` was used in a context where it's not directly available, typically at the top level of the `outputs` attribute set when not iterating over systems.
*   **Diagnosis**: Look for `.${builtins.currentSystem}` in your `flake.nix`.
*   **Solution**: Use `flake-utils.lib.eachDefaultSystem` to iterate over systems, passing `system` as an argument to your output functions. Remember to add `flake-utils` as an input to your flake.

### 5.3. Flake Resolution Issues (e.g., `path '.../flakes"' does not contain a 'flake.nix'`, `'.' is not a commit hash`)

*   **Cause**: Nix is having trouble locating or interpreting your `flake.nix` file or its inputs. This can be due to incorrect paths, quoting issues, or an older/misconfigured Nix environment.
*   **Diagnosis**:
    *   Verify the exact Nix command being executed.
    *   Check for any unusual characters or quotes in the path or arguments.
    *   Ensure `flake.nix` is in the expected location (usually the project root).
*   **Solution**:
    *   Ensure experimental features are correctly enabled (e.g., `export NIX_CONFIG="experimental-features = nix-command flakes"`).
    *   Use the simplest possible flake reference: `nix build .#<attribute>`.
    *   If using `flake:./.#<attribute>`, ensure no extra quotes are being added by the shell.
    *   Verify your `nixpkgs.url` input is correct for your project (e.g., `github:meta-introspector/nixpkgs?ref=...`).

### 5.4. Experimental Features Not Enabled

*   **Cause**: Nix flakes and `nix-command` are experimental features and must be explicitly enabled.
*   **Diagnosis**: Look for warnings like "unknown experimental feature".
*   **Solution**: Enable experimental features either via `NIX_CONFIG` environment variable (`export NIX_CONFIG="experimental-features = nix-command flakes"`) or by passing `--extra-experimental-features "nix-command flakes"` to every Nix command. Using `NIX_CONFIG` is generally more robust for scripts.

## 6. Debugging Techniques

*   **Simplify the Command**: If a complex Nix command fails, try to break it down. Can `nix flake check` parse your flake? Can `nix develop` enter your shell?
*   **Enter the Development Shell**: Use `nix develop` to enter the flake's development shell. This allows you to interactively test commands and inspect the environment that Nix sets up.
*   **Inspect the Build Environment**: Within a `pkgs.runCommand` or similar derivation, you can add `echo` statements or even `ls -laR $src` to understand what files are available and where.
*   **Check `flake.lock`**: Ensure your `flake.lock` is up-to-date and correctly reflects your inputs. Run `nix flake update` if necessary (but commit first!).

## 7. Importance of Committing

Always adhere to the "SOP: Commit Before Nix Operations". Uncommitted changes can lead to non-reproducible builds and make debugging significantly harder. Ensure your Git repository is in a clean state before attempting Nix builds.
