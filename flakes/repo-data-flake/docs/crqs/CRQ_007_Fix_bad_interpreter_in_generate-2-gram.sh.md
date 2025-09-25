# CRQ-007: Fix bad interpreter in generate-2-gram.sh

## Problem

The `generate_2gram_report.sh` script is failing because the `generate-2-gram.sh` script has a shebang that points to `/bin/bash`, but that path doesn't exist in the Nix build environment.

## Solution

The solution is to change the shebang in `generate-2-gram.sh` to `#!/usr/bin/env bash`. This will tell the system to find the `bash` executable in the environment, which will be available in the Nix build environment.
