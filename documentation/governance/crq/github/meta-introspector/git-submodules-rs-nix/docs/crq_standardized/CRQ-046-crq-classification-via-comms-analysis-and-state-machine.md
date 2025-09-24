**CRQ: CRQ Classification via Comms Analysis and State Machine**

**Problem/Goal:**
To achieve a more deterministic, nuanced, and robust classification of CRQs by analyzing the entire sequence and content of CoderabbitAI's communications, moving beyond simple keyword presence. This aims to infer a "state" or fine-grained classification for each CRQ based on its communication history.

**Proposed Solution:**

1.  **Communication Concatenation:**
    *   For each CRQ, read all CoderabbitAI communication files (e.g., `001_coderabbitai.md`, `006_coderabbitai.md`).
    *   Concatenate their content into a single, ordered string representing the full communication history for that CRQ.

2.  **State Definition:**
    *   Clearly define the "states" or classifications to be derived from the communication analysis. Examples include:
        *   `ReviewSkippedNoFollowUp`: Initial skip, no subsequent meaningful review.
        *   `ReviewProvided`: A detailed review was given.
        *   `ClarificationRequested`: CoderabbitAI asked a question.
        *   `ErrorEncountered`: CoderabbitAI reported an internal error.
        *   `ReadyForMerge`: CoderabbitAI indicated the PR is ready.
        *   `ActionRequiredFromUser`: CoderabbitAI requested a specific action from the user.

3.  **DFA/Complex Regex/Rule-Based System Implementation:**
    *   **Rule-Based System (Recommended for NLP):** Implement a sophisticated rule-based system that operates on the concatenated communication string. This system would:
        *   Extract key features (e.g., presence of specific keywords, phrases, or patterns indicating review status, questions, errors, or action items).
        *   Apply a series of prioritized `if-then-else` rules to these features to determine the final "state" of the CRQ.
    *   (Alternative: DFA/Complex Regex for simpler, sequential patterns, but less practical for natural language variability).

**Justification/Impact:**
This enhancement will significantly improve the accuracy and intelligence of CRQ classification by leveraging the rich context available in communication logs. It will enable:
*   More precise identification of CRQs requiring specific actions (e.g., manual review requests, direct responses).
*   Better understanding of the lifecycle and progress of each CRQ based on CoderabbitAI's interactions.
*   Reduced false positives in classifications by considering the full communication history.
*   A more automated and reliable triage system for CRQs.