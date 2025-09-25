# CRQ-002: Prevent nix from writing lock files

## Problem

The `nix` commands in our scripts are failing because they are trying to write a `flake.lock` file, but the file is ignored by our `.gitignore` file. This causes `git` to fail, which in turn causes `nix` to fail.

## Solution

The solution is to add the `--no-write-lock-file` flag to all the `nix` commands in our scripts. This will prevent `nix` from writing a lock file.
