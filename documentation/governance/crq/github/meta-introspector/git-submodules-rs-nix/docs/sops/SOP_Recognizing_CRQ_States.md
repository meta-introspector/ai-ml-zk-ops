## SOP: Recognizing CRQ States - Review Skipped Due to Size Limit

### 1. Introduction
This Standard Operating Procedure (SOP) outlines the process for recognizing a specific CRQ state: `ReviewSkippedDueToSizeLimit`. This state indicates that an automated code review by CoderabbitAI was skipped because the changes (files, lines of code, etc.) exceeded a predefined size limit. Recognizing this state is crucial for efficient project management, allowing for appropriate follow-up actions such as manual review requests or adjustments to review configurations.

### 2. Definition of `ReviewSkippedDueToSizeLimit` State

A CRQ is classified as `ReviewSkippedDueToSizeLimit` if the CoderabbitAI response associated with the CRQ explicitly indicates that the review was skipped due to size constraints. This typically includes messages referencing "max files limit," "exceeds size limit," or the overall "too large" nature of the changes for automated processing.

### 3. Recognition Mechanism (New Module: `crq_state_recognizer`)

To programmatically identify the `ReviewSkippedDueToSizeLimit` state, a new Rust module, `crq_state_recognizer`, will be introduced. This module will contain a dedicated function responsible for analyzing CoderabbitAI communication content.

#### 3.1. Module Location
The `crq_state_recognizer` module will be located at `src/crq_state_recognizer.rs`.

#### 3.2. Key Function: `is_review_skipped_due_to_size_limit`

```rust
pub fn is_review_skipped_due_to_size_limit(coderabbitai_response_content: &str) -> bool {
    let lower_content = coderabbitai_response_content.to_lowercase();

    // Keywords and phrases indicating a skipped review due to size
    let size_limit_keywords = [
        "review skipped",
        "max files limit",
        "exceeds size limit",
        "too large",
        "low-quality review", // Often associated with skipped reviews due to size
    ];

    // Check if any of the keywords are present in the content
    size_limit_keywords.iter().any(|&keyword| lower_content.contains(keyword))
}
```

#### 3.3. Logic
The `is_review_skipped_due_to_size_limit` function will perform a case-insensitive search for a predefined set of keywords and phrases within the provided CoderabbitAI response content. If any of these indicators are found, the function will return `true`, signifying that the `ReviewSkippedDueToSizeLimit` state has been detected.

### 4. Integration with `determine_next_step`

The `ReviewSkippedDueToSizeLimit` state will be added to the `NextStep` enum in `tools/crq_table_generator/src/crq_parser.rs`. The `determine_next_step` function within the same file will be updated to prioritize the detection of this new state. It will call `is_review_skipped_due_to_size_limit` and, if `true` is returned, classify the CRQ accordingly.

### 5. Test Cases
Comprehensive unit tests for `is_review_skipped_due_to_size_limit` will be located in `tests/test_crq_state_recognizer.rs`. These tests will cover various scenarios, including positive matches for different keywords and negative cases where the state should not be recognized.

*   **`test_is_review_skipped_due_to_size_limit_positive_low_quality_review`**: Verifies that the function correctly identifies a skipped review when the CoderabbitAI response explicitly mentions preventing a "low-quality review" due to size implications, even without direct mentions of "max files limit" or "exceeds size limit."

### 6. Impact and Benefits
Introducing the `ReviewSkippedDueToSizeLimit` state and its recognition mechanism will:
*   Provide more granular and accurate classification of CRQs.
*   Enable automated systems to better understand the reasons for skipped reviews.
*   Facilitate more targeted follow-up actions (e.g., notifying developers, adjusting CoderabbitAI configurations, or initiating manual reviews for large changes).
*   Improve the overall efficiency and determinism of the CRQ processing pipeline.
