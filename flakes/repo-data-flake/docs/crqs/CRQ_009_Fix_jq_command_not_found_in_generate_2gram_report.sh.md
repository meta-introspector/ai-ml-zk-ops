# CRQ-009: Fix jq: command not found in generate_2gram_report.sh

## Problem

The `generate_2gram_report.sh` script is failing because the `jq` command is not available in the environment where the script is being run.

## Solution

The solution is to add `jq` as a `buildInput` to the derivation that runs the `generate_2gram_report.sh` script.
