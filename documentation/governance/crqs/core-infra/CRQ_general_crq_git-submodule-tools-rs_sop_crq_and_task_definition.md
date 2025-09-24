---
original_path: documentation/governance/crqs/docs-process/CRQ_git-submodule-tools-rs_sop_crq_and_task_definition.md
original_filename: CRQ_git-submodule-tools-rs_sop_crq_and_task_definition.md
conceptual_category: core-infra
project_context: general
---

---
original_path: documentation/governance/crqs/github/meta-introspector/git-submodule-tools-rs/docs/sop_crq_and_task_definition.md
original_filename: sop_crq_and_task_definition.md
conceptual_category: docs-process
project_context: git-submodule-tools-rs
---

# Standard Operating Procedure: Change Request (CRQ) and Task Definition

## Characteristics of a Change Request (CRQ):

*   **Task Association:** Each task is an integral part of a larger Change Request (CRQ).
*   **Intent-Driven:** Every CRQ is defined by a clear intent, which can be characterized by its:
    *   **Vibe/Vector:** The overall direction or sentiment.
    *   **Embedding/Encoding:** Its representation in a structured or numerical form.
    *   **Decidability:** The ability to determine its outcome.
    *   **Finiteness:** A defined scope with a clear beginning and end.
    *   **Discreteness:** A distinct and separate unit of work.
    *   **Limited Scope:** Confined within specific boundaries.
    *   **Constraints:** Operating under defined restrictions.

## Task Execution Environment:

*   **Local Git Access:** Tasks are restricted to accessing local Git upstream repositories only; no GitHub API keys or external network access to GitHub are permitted.
*   **Sandboxed Environment:** Each task operates within a sandboxed environment with Access Control Lists (ACLs) to ensure isolation and security.