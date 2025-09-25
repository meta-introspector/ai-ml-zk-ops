# CRQ-008: Fix src attribute missing in add-2gram-script flake

## Problem

The `add-2gram-script` flake is failing to evaluate because the `repoDataFlakeRoot` input does not have a `src` attribute.

## Solution

The solution is to build the top-level flake instead of building each flake individually. This will ensure that the `add-2gram-script` flake has access to the `src` attribute of the top-level flake.

We will modify the `Makefile` to only build the top-level flake. We will also modify the top-level flake to expose the outputs of the other flakes.
