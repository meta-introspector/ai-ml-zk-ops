# Debugging Nix Flakes

This tutorial explains how to debug Nix flakes using the `nix` command-line tool.

## Inspecting Flake Outputs

The `nix flake show` command allows you to inspect the outputs of a flake. This is useful for understanding what a flake provides and for debugging problems with the flake's outputs.

To show the outputs of a flake, you can use the following command:

```bash
nix flake show <flake-url>
```

For example, to show the outputs of the `nixpkgs` flake, you can run:

```bash
nix flake show github:NixOS/nixpkgs
```

This will print a tree-like structure showing all the outputs of the flake.

### JSON Output

You can also get the output in JSON format using the `--json` flag:

```bash
nix flake show --json <flake-url>
```

This is useful for programmatically inspecting the outputs of a flake.

## Debugging Flake Evaluation

If a flake is failing to evaluate, you can use the `--debugger` flag to start an interactive debugger.

```bash
nix --debugger eval <flake-url>#<output>
```

This will drop you into a `nix repl` session where you can inspect the state of the evaluation and try to identify the problem.

### Verbose Logging

You can use the `--verbose` or `-v` flag to increase the verbosity of the logging. This can be useful for understanding what's happening during the evaluation of a flake.

```bash
nix -v eval <flake-url>#<output>
```

### Log Format

You can use the `--log-format` flag to change the format of the log output. The `bar-with-logs` format is particularly useful for debugging, as it shows the logs for each build step.

```bash
nix --log-format bar-with-logs build <flake-url>#<output>
```

## Tutorial: Debugging a Failing Flake

Let's say you have a flake that is failing to evaluate with the following error:

```
error: attribute 'foo' missing
```

To debug this, you can use the `--debugger` flag to start an interactive debugger:

```bash
nix --debugger eval .#my-package
```

This will drop you into a `nix repl` session. From here, you can inspect the `self` variable to see the outputs of the flake.

```
nix-repl> self
{ outputs = { ... }; }
```

You can then inspect the `outputs` to see if the `foo` attribute is present.

If the attribute is not present, you can then inspect the `flake.nix` file to see why it's not being defined.
