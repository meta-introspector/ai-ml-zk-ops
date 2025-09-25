# CRQ-004: Build a lattice of introspection

## Problem

We want to gain a deeper understanding of how our Nix flakes are evaluated. We need a systematic way to add more detailed tracing and debugging to our flakes and to analyze the output.

## Solution

We will build a "lattice of introspection" by adding progressively more detailed tracing and debugging to our flakes. We will create new scripts and `Makefile` targets to generate the output of each level of the lattice. We will then use our 2-gram analysis to compare the logs and see what new information is revealed at each level.

### Lattice Levels

*   **Level 0 (Baseline):** Our current setup.
*   **Level 1 (Verbose):** Add the `--verbose` or `-v` flag to our `nix` commands.
*   **Level 2 (Debug):** Add the `--debug` flag to our `nix` commands.
*   **Level 3 (Trace):** Use the `trace` function in our Nix expressions.
*   **Level 4 (Function Call Trace):** Use the `traceFunctionCalls` option.
