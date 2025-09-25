# CRQ-003: Add src attribute to top-level flake

## Problem

The top-level `flake.nix` file is failing to evaluate because the `self` attribute does not have a `src` attribute. This causes the following error:

```
error: attribute 'src' missing
```

## Solution

The solution is to add `self.src = ./.;` to the flake's outputs. This will tell Nix to use the current directory as the source of the flake.
