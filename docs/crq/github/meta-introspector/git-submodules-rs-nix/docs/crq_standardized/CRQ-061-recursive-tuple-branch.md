# CRQ-061: Recursive Tuple Branch for Concurrent Branch Management

## Problem
Managing multiple feature branches concurrently within a single repository can become cumbersome, leading to frequent context switching, merge conflicts, and difficulty in visualizing the overall state of parallel development efforts. Creating separate repositories for every feature leads to repository sprawl and fragmented project views.

## Solution
Implement a "recursive tuple branch" strategy where the main repository contains submodules that point back to itself, but to different branches. This allows developers to check out a "tuple branch" and have multiple feature branches (or even `main`) available as submodules within a single working directory, facilitating concurrent work and holistic project views.

## Motivation:
*   **Avoid Repository Sprawl:** Consolidate related development efforts within a single repository structure, rather than creating numerous independent repositories.
*   **Concurrent Branch Work:** Enable developers to work on and test multiple feature branches simultaneously without constantly switching branches or managing separate clones.
*   **Holistic View:** Provide a unified view of the project's state across different development lines.

## Proposed Implementation (Conceptual):
*   A dedicated directory (e.g., `self/branches/`) within the main repository will house the submodules.
*   Each submodule within `self/branches/` will point to the *same* parent repository, but to a *specific branch* (e.g., `feature_X`, `feature_Y`, `main`).
*   When a developer checks out a "tuple branch," they will initialize and update these submodules, bringing the content of the specified branches into their working directory.

## Considerations & Challenges (Acknowledged):
*   **Complexity:** This is an advanced Git pattern that introduces significant complexity in setup, maintenance, and daily operations.
*   **Self-Referential Nature:** Managing a repository as a submodule of itself can lead to intricate dependency graphs and potential for infinite recursion if not handled with extreme care.
*   **Tooling Compatibility:** Standard Git tools, IDEs, and CI/CD pipelines may not fully support or be optimized for such a self-referential structure, potentially requiring custom scripting or workarounds.
*   **Merge/Rebase Operations:** Operations like merging or rebasing the parent repository can become significantly more complex when submodules point back to the parent's history.
*   **Performance:** A large number of submodules could impact Git operation performance.

## Future Scope (Wikidata Tool):
The `wikidata` tool, intended to be its own binary, can be integrated into this structure as a distinct submodule or managed as a separate project, depending on its specific requirements and the evolution of this "recursive tuple branch" strategy.

## Application: Incident Management with Template Repositories

This CRQ's principles extend to robust incident management. By leveraging dedicated submodule repositories for each incident, we gain significant advantages:

*   **Data Bloat Isolation:** Incident branches can accumulate extensive data (logs, diagnostics, temporary fixes, etc.) without bloating the main repository's history. Each incident's data is self-contained within its submodule.
*   **Private Repository Management:** Incident submodules can be hosted in private repositories, ensuring sensitive incident data remains secure and accessible only to authorized personnel.
*   **Encryption Capabilities:** The isolated nature of incident submodules allows for granular encryption strategies. Individual incident repositories can be encrypted independently, adding an extra layer of security.
*   **Mergeability with Other Incident Branches:** While each incident is distinct, the submodule approach allows for easier merging or comparison of common fixes or patterns across different incidents, if needed, without directly impacting the main codebase.

## Future Vision: Template Repositories as Types - The Ultimate Templating

Building upon this foundation, the long-term vision is to rebuild the entire project using the principle of "template repositories as types." This paradigm shift represents the **ultimate templating** approach, where every component, tool, or module is a manifestation of a well-defined template.

The core idea is encapsulated by the formula: **Tool = Template + Prelude + Vibe**.

*   **Template:** A base repository (like `tool-template-repo`) that provides the fundamental structure, build system, and initial boilerplate for a specific "type" of component (e.g., a Rust CLI tool, a library, a web service).
*   **Prelude:** A common submodule (like `rust-tool-prelude`) included by the template. This prelude contains shared utilities, common configurations, and foundational code that all instances of that template type will utilize. This ensures consistency and reduces redundancy across similar components.
*   **Vibe:** The unique, specific logic and implementation that differentiates one instance of a template from another. This is the custom code written for the particular tool or component, built upon the foundation provided by the template and prelude.

This approach offers:

*   **Clean Template and Submodule Management:** Templates are managed as independent repositories, allowing for their evolution and versioning. Submodules cleanly integrate these templates and preludes into specific projects, ensuring that updates can be pulled and merged systematically.
*   **Standardized Structures:** Every major component, feature, or data type within the project would originate from a predefined template repository, ensuring architectural consistency.
*   **Versioned Templates:** Templates themselves would be versioned, allowing for controlled evolution and updates across the project.
*   **Automated Generation:** Tools (like our `incident-submodule-manager`) would automate the creation and integration of new components based on these templates, ensuring consistency and reducing boilerplate.
*   **Enhanced Modularity:** This approach would enforce strict modularity, making it easier to manage dependencies, scale development, and maintain a clean architecture.
*   **Type-Driven Development:** The "type" of a component would be defined by its originating template repository, guiding its structure, behavior, and integration points.
