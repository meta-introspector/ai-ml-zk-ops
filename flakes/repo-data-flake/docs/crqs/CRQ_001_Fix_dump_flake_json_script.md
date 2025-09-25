# CRQ-001: Fix dump_flake_json.sh script

## Problem

The `dump_flake_json.sh` script is failing because it's using `nix flake show` with a path to a `flake.nix` file instead of a flake reference. This causes the following error:

```
error: in flake URL '<path-to-flake.nix>', '<flake.nix>' is not a commit hash
```

## Solution

The solution is to change the command in `dump_flake_json.sh` to use `nix flake show --json --all-systems .` and to run the script from the directory containing the `flake.nix` file. This will tell `nix` to treat the current directory as a flake.
