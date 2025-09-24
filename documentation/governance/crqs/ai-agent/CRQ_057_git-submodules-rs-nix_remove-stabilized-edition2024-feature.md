---
original_path: documentation/governance/crqs/github/meta-introspector/git-submodules-rs-nix/docs/crq_standardized/CRQ-057-remove-stabilized-edition2024-feature.md
original_filename: CRQ-057-remove-stabilized-edition2024-feature.md
conceptual_category: ai-agent
project_context: git-submodules-rs-nix
---

**CRQ Title:** CRQ-057: Remove Stabilized `edition2024` Feature from Cargo.toml Files

**Problem/Goal:**
The `edition2024` cargo feature is explicitly listed in several `Cargo.toml` files, but it has been stabilized in Rust 1.85 and is no longer necessary. This CRQ aims to remove these redundant entries to clean up project configuration.

**Proposed Solution:**
Remove the `edition2024` entry from the `[features]` section of the affected `Cargo.toml` files.

**Affected Files:**
*   `lattice_code_generator/Cargo.toml`
*   `lattice_structure_generator/Cargo.toml`
*   `tools/crq-parser/Cargo.toml`
*   `lattice_generator_app/Cargo.toml`

**Justification/Impact:**
Removing redundant feature flags improves the clarity and maintainability of `Cargo.toml` files, aligning them with the latest Rust best practices.