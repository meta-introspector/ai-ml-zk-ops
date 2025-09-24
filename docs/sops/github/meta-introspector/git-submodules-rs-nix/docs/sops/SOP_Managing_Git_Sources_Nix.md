# Standard Operating Procedure (SOP) for Managing Git Sources in Nix Flakes

## 1. Introduction

This SOP details the methods for fetching and managing Git repositories within Nix flakes, focusing on `builtins.fetchGit` and `pkgs.fetchgit`, and addressing common issues like `.git` directory preservation and hash mismatches.

## 2. Fetching Git Repositories

Nix provides several ways to fetch Git repositories. The choice depends on whether you need a full Git working copy or just the source files.

### 2.1 `builtins.fetchGit`

`builtins.fetchGit` is a built-in function for fetching Git repositories. By default, it fetches the contents of the repository but does not preserve the `.git` directory in a way that makes it a functional Git working copy within the Nix build sandbox.

**Usage**:

```nix
repo = builtins.fetchGit {
  url = "https://github.com/example/repo.git";
  rev = "<commit-hash-or-branch>";
  # submodules = true; # Use this to fetch submodules
};
```

**Considerations**:
*   **No Functional `.git` Directory**: If you need to run `git` commands (like `git submodule init`) that require a working Git repository, `builtins.fetchGit` alone is usually insufficient.
*   **Fixed-Output Derivation**: Requires a `sha256` hash for reproducibility. If the content changes, the hash will mismatch.

### 2.2 `pkgs.fetchgit`

`pkgs.fetchgit` is a Nixpkgs function that wraps `builtins.fetchGit` and provides additional features, such as `deepClone` to fetch submodules.

**Usage**:

```nix
repo = pkgs.fetchgit {
  url = "https://github.com/example/repo.git";
  rev = "<commit-hash-or-branch>";
  deepClone = true; # Fetches submodules and attempts to preserve .git directory structure
  sha256 = "<expected-sha256-hash>";
};
```

**Considerations**:
*   **`deepClone = true`**: This option attempts to fetch submodules and create a more complete Git repository structure. However, it might still not be sufficient for all `git` commands within the strict Nix build sandbox.
*   **Fixed-Output Derivation**: Like `builtins.fetchGit`, it requires a `sha256` hash. Always update the hash if the source content changes.

## 3. Handling `.git` Directory Preservation

When `git` commands (especially `git submodule init` or `git submodule update`) are required within a Nix derivation, the source provided to the derivation must be a functional Git repository. Standard `fetchGit` functions often don't provide this.

### 3.1 Using `pkgs.lib.cleanSource` with `keepGitDir = true`

This function can be used to clean a source (e.g., remove untracked files) while explicitly preserving the `.git` directory, making it a functional Git repository.

**Usage**:

```nix
src = pkgs.lib.cleanSource {
  src = builtins.fetchGit { # or pkgs.fetchgit
    url = "https://github.com/example/repo.git";
    rev = "<commit-hash-or-branch>";
    # ... other fetchGit options
  };
  keepGitDir = true;
};

pkgs.runCommand "my-derivation" {
  inherit src;
  buildInputs = [ pkgs.git ];
} ''
  cd $src
  git submodule init
  git submodule update --recursive
  # ... other git commands
'';
```

**Considerations**:
*   `pkgs.lib.cleanSource` returns a set, so you must use `src.outPath` if the context expects a string path (e.g., `src = src.outPath;`). However, `pkgs.runCommand`'s `src` argument often handles derivations directly.

## 4. Addressing Hash Mismatches

When using fixed-output derivations like `builtins.fetchGit` or `pkgs.fetchgit`, a `hash mismatch` error indicates that the fetched content's hash does not match the `sha256` specified in your `flake.nix`.

**Problem**: `error: hash mismatch in fixed-output derivation ... specified: <old-hash> got: <new-hash>`

**Cause**: The content of the Git repository (or its submodules, if `submodules = true` or `deepClone = true` is used) has changed since the `sha256` was last updated.

**Solution**: Update the `sha256` hash in your `flake.nix` to the `got` hash provided in the error message.

**Example**:

```nix
repo = pkgs.fetchgit {
  url = "https://github.com/example/repo.git";
  rev = "<commit-hash-or-branch>";
  deepClone = true;
  sha256 = "<new-hash-from-error-message>"; # Update this line
};
```

## 5. Best Practices

*   **Pin Revisions**: Always use specific commit hashes (`rev`) instead of branch names to ensure reproducibility.
*   **Update Hashes**: Regularly update `sha256` hashes when upstream repositories change. Tools like `nix-prefetch-git` or `nix-update` can help automate this.
*   **Understand Sandbox Limitations**: Be aware that the Nix build sandbox is isolated. Direct `git` commands requiring a full working repository might be challenging. Consider alternative approaches like manually copying files if `git submodule` commands prove problematic.
*   **Iterative Debugging**: When encountering issues, simplify the derivation and test each component (fetching, `git` commands) individually.
