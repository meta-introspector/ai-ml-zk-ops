# CRQ-011: Fix nix run command in generate_2gram_report.sh

## Problem

The `generate_2gram_report.sh` script is failing because the `nix run` command is trying to execute a file that doesn't exist.

## Solution

The solution is to change the `nix run` command to specify the package that we want to run. The correct command is `nix run .#repo2gramJson`.
