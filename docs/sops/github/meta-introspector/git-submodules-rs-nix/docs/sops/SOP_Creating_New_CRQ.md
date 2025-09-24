# SOP: Creating a New CRQ

## Purpose

This Standard Operating Procedure (SOP) outlines the steps for creating a new Change Request/Question (CRQ) document using the `new_crq.sh` script. This ensures consistency in CRQ formatting and proper numbering.

## Prerequisites

* The `new_crq.sh` script must be available in the `tools/` directory and have execute permissions.
* The `docs/crq_standardized/` directory must exist.

## Procedure

1.  **Navigate to the Project Root:**
    Open your terminal and navigate to the root directory of the `meta-introspector/submodules` project.

    ```bash
    cd /path/to/meta-introspector/submodules
    ```

2.  **Create a New CRQ:**
    Execute the `new_crq.sh` script, providing the title of your new CRQ enclosed in double quotes.

    ```bash
    ./tools/new_crq.sh "Your New CRQ Title Here"
    ```

    **Example:**
    ```bash
    ./tools/new_crq.sh "Refactor Database Connection Logic"
    ```

    This will create a file like `docs/crq_standardized/CRQ-055-refactor-database-connection-logic.md` (the number will vary based on the last existing CRQ).

3.  **Edit the New CRQ File:**
    After the script creates the file, it will prompt you to edit it. Open the newly created `.md` file in your preferred text editor.

    ```bash
    # Example using nano
    nano docs/crq_standardized/CRQ-XXX-your-new-crq-title-here.md
    ```

4.  **Fill in the CRQ Details:**
    Complete the "Problem/Goal," "Proposed Solution," and "Justification/Impact" sections within the CRQ template. Be as clear and concise as possible.

5.  **Save and Close:**
    Save your changes and close the text editor.

## Troubleshooting

*   **"Usage: ./tools/new_crq.sh \"<CRQ Title>\""**: You did not provide a title for the CRQ, or the title was not enclosed in double quotes if it contained spaces.
*   **"Error: CRQ file already exists:"**: A CRQ with the generated filename already exists. This might happen if you try to create the same CRQ twice, or if there's a numbering conflict.

## Related Documents

*   [SOP_Using_CRQ_Classifier.md](SOP_Using_CRQ_Classifier.md)
*   [SOP_Generating_CRQ_Report.md](SOP_Generating_CRQ_Report.md)
