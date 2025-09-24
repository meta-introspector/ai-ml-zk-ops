# Standard Operating Procedure (SOP) for Nix Flake Debugging and Rust Build Environment Configuration

## 1. Introduction

This SOP outlines common issues and their resolutions when debugging Nix flakes for Rust projects, particularly concerning `CARGO_HOME`, `pkg-config`, and `openssl-sys` dependencies. These issues often manifest as build failures related to missing tools or libraries during the Rust compilation process within the Nix build environment.

## 2. Common Issues and Solutions

### 2.1 `CARGO_HOME` Not Writable

**Problem**: Rust builds fail because `CARGO_HOME` is not set to a writable directory within the Nix build sandbox.

**Solution**: Explicitly set `CARGO_HOME` to a writable temporary directory, typically `$TMPDIR/.cargo`, within the `pkgs.runCommand` or `pkgs.rustPlatform.buildRustPackage` derivation.

**Example (`flake.nix` snippet)**:

```nix
            pkgs.runCommand "my-rust-project" {
              buildInputs = [ toolchain ];
              CARGO_HOME = "$TMPDIR/.cargo"; # Set CARGO_HOME to a writable directory
            } ''
              mkdir -p $CARGO_HOME # Create the directory
              cargo test
              touch $out
            '';
```

### 2.2 `pkg-config` Not Found / OpenSSL Linking Issues

**Problem**: Rust crates (especially those depending on `openssl-sys` or `libgit2`) fail to build because `pkg-config` cannot be found or OpenSSL libraries are not correctly linked.

**Root Cause**: The Nix build environment might not expose `pkg-config` or OpenSSL development files in a way that the Rust build system (specifically `openssl-sys`) expects.

**Solutions (Iterative Approach)**:

1.  **Add `pkgs.pkg-config` to `buildInputs`**: Ensure the `pkg-config` utility is available in the build environment.

    ```nix
    buildInputs = [ pkgs.pkg-config ];
    ```

2.  **Add `pkgs.openssl` to `buildInputs`**: Provide the OpenSSL development libraries.

    ```nix
    buildInputs = [ pkgs.pkg-config pkgs.openssl ];
    ```

3.  **Add C Standard Library Development Files (`pkgs.stdenv.cc.libc_dev`)**: Sometimes, underlying C library issues can manifest as `pkg-config` problems.

    ```nix
    buildInputs = [ pkgs.pkg-config pkgs.openssl pkgs.stdenv.cc.libc_dev ];
    ```

4.  **Explicitly Set `PKG_CONFIG_PATH`**: Manually set the `PKG_CONFIG_PATH` environment variable within the derivation to point to the `pkg-config` directories of the required packages.

    ```nix
    env = {
      PKG_CONFIG_PATH = "${pkgs.pkg-config}/lib/pkgconfig:${pkgs.openssl}/lib/pkgconfig";
    };
    ```

5.  **Disable Problematic Features (e.g., `git2-support`)**: If a dependency (like `git2` in `submod`) is optional and causes persistent linking issues, consider disabling its default features if the tool has a fallback mechanism (e.g., using the `git` CLI directly).

    ```nix
    pkgs.rustPlatform.buildRustPackage {
      # ... other attributes
      defaultFeatures = false; # Disable features that pull in problematic dependencies
      # features = [ "some-other-feature" ]; # Optionally enable other desired features
    };

### 2.3 `rust-toolchain.toml` and Nix Toolchain Management

**Problem**: Inconsistent Rust toolchain versions between local development and Nix builds, leading to compilation errors or unexpected behavior.

**Solution**: Ensure that the `rust-toolchain.toml` file in the project root (or crate root) is aligned with the Rust toolchain provided by Nix. Nix's `rust-overlay` or `pkgs.rustPlatform` typically provides a specific Rust toolchain. If `rust-toolchain.toml` specifies a different version or components, it can cause conflicts. Consider removing `rust-toolchain.toml` if Nix is the sole source of truth for the toolchain, or ensure it points to a compatible version.

**Best Practice**: For Nix-managed Rust projects, it's often best to let Nix fully manage the Rust toolchain. If `rust-toolchain.toml` is used, ensure it's compatible with the Nix-provided toolchain or used in conjunction with `nix-shell` or `direnv` to load the Nix-provided toolchain.
    ```

## 3. Debugging Process

When encountering build failures related to Rust dependencies in Nix flakes, follow an iterative debugging process:

1.  **Read the Logs**: The Nix build logs provide crucial information. Look for specific error messages (e.g., "`pkg-config` not found", "linker errors").
2.  **Identify Missing Dependencies**: Based on the error messages, identify which system libraries or tools are missing from the build environment.
3.  **Add to `buildInputs`**: Incrementally add the identified dependencies to the `buildInputs` attribute of your derivation.
4.  **Environment Variables**: If adding to `buildInputs` doesn't resolve the issue, consider explicitly setting relevant environment variables (e.g., `PKG_CONFIG_PATH`, `LD_LIBRARY_PATH`) within the `env` attribute of your derivation.
5.  **Feature Management**: For Rust crates, investigate their `Cargo.toml` for optional features that might be pulling in problematic native dependencies. Disable default features or selectively enable only necessary ones.
6.  **Consult Nixpkgs**: Search the Nixpkgs repository or documentation for examples of how similar Rust projects or libraries are packaged, as they often contain solutions for common build issues.

## 4. Best Practices

*   **Start Simple**: Begin with minimal `buildInputs` and add more only as required by build errors.
*   **Explicit Dependencies**: Always explicitly list all build-time dependencies in `buildInputs`.
*   **Reproducible Builds**: Leverage `flake.lock` to ensure that the exact versions of all dependencies are used, preventing unexpected build failures due to upstream changes.
*   **Iterative Testing**: Test changes to `flake.nix` frequently by attempting to build the affected derivation.
