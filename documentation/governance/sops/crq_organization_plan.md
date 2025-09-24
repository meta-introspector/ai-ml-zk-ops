# SOP: CRQ Organization Plan

This document outlines the iterative process for reorganizing Change Request (CRQ) files within the repository, ensuring conceptual grouping, metadata preservation, and a consistent naming convention.

## Process Overview

For each identified CRQ file:

1.  **Determine Conceptual Category:** Assign the CRQ to one of the five defined conceptual categories based on its content and theme.
2.  **Extract Project Context:** Identify the relevant sub-project or module from the CRQ's original file path. If no specific sub-project is evident, use "general" or "meta-introspector" as context.
3.  **Construct New Filename:** Create a new filename that embeds the project context and ensures sorting by CRQ number. The general format will be `CRQ_<CRQ_NUMBER>_<PROJECT_CONTEXT>_<ORIGINAL_TITLE_SLUG>.md`.
4.  **Construct New Full Path:** The new path will follow the structure: `documentation/governance/crqs/<CONCEPTUAL_CATEGORY>/<NEW_FILENAME>`.
5.  **Read Original Content:** Retrieve the content of the original CRQ file.
6.  **Add Metadata Header:** Prepend a YAML-like metadata header to the content, tracking:
    *   `original_path`: The full path of the original file.
    *   `original_filename`: The original filename.
    *   `conceptual_category`: The assigned conceptual category.
    *   `project_context`: The extracted project context.
7.  **Write Modified Content:** Write the new content (metadata + original content) to the new full path.
8.  **Delete Original File:** Remove the original CRQ file.

## Conceptual Categories for CRQs

The five primary conceptual categories for CRQ organization are:

1.  **`core-infra/`**: CRQs related to Nix, flakes, submodules, Git operations, and general repository management.
2.  **`ai-agent/`**: CRQs related to AI, LLMs, agents, and their operational frameworks.
3.  **`docs-process/`**: CRQs related to documentation, SOPs, task management, and quality assurance.
4.  **`conceptual-research/`**: CRQs related to abstract concepts, introspection, lattice theory, memes, and specific research topics (like Monster Group).
5.  **`vendor-integrations/`**: CRQs related to vendorizing external dependencies or integrating with external tools/platforms.

## Filename Convention

The new filename convention aims to make CRQ numbers act as "lattice grid coordinates" for sorting and quick identification. The format is designed to be `CRQ_<CRQ_NUMBER>_<PROJECT_CONTEXT>_<ORIGINAL_TITLE_SLUG>.md`. This ensures that files sort logically by their CRQ identifier while retaining project context.

## Cleanup

After all files have been processed, any empty original directories (e.g., `github/meta-introspector/...`) will be removed.
