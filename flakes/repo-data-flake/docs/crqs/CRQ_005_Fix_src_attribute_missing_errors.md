# CRQ-005: Fix 'src' attribute missing errors

## Problem

The `tests/error-script-not-found/flake.nix` and `flakes/add-2gram-script/flake.nix` files are failing to evaluate because the `self` attribute does not have a `src` attribute.

## Solution

The solution is to add `self.src = ./.;` to the flake's outputs. This will tell Nix to use the current directory as the source of the flake.
