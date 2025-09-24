pub struct Crq {
    pub problem_goal: String,
    pub proposed_solution: String,
    pub justification_impact: String,
}

#[derive(Debug, PartialEq, Eq, Hash, Clone, Copy)]
pub enum NextStep {
    IssueTooLarge,              // New: CoderabbitAI indicates issue is too large
    OverQuota,                  // New: CoderabbitAI indicates rate limit/over quota
    ReviewSkippedDueToSizeLimit, // New: Review skipped due to size limit
    ReviewProvided,             // CoderabbitAI has provided a meaningful review
    ReviewSkipped,              // CoderabbitAI skipped, no meaningful review
    ReviewNeededFromCoderabbitAI, // We need to request a review from CoderabbitAI
    Develop,
    Refactor,
    Document,
    RespondToHuman,             // Our turn for human attention/decision
    Unknown,
}

#[derive(Debug, PartialEq, Eq, Clone)]
pub enum CoderabbitAIResponseType {
    SkippedMessage,
    RateLimitMessage,
    ReviewSummary,
    QuestionMessage,
    Other,
}

pub struct CommsAnalysisResult {
    pub skipped_review_present: bool,
    pub response_count: usize,
    pub total_size: usize,
    pub meaningful_response_present: bool,
    pub contains_issue_too_large: bool,
    pub contains_over_quota: bool,
    pub individual_responses: Vec<(CoderabbitAIResponseType, String)>,
}

use regex::Regex;
use lazy_static::lazy_static;


lazy_static! {
    static ref WORD_REGEX: Regex = Regex::new(r"[a-z]+").unwrap();
}

fn extract_tokens(text: &str) -> Vec<String> {
    let words: Vec<String> = WORD_REGEX.find_iter(&text.to_lowercase())
        .map(|m| m.as_str().to_string())
        .collect();

    let mut tokens = Vec::new();

    // Add single words (1-grams)
    tokens.extend(words.clone());

    // Add n-grams
    let n_gram_lengths = vec![2, 3, 5, 7, 11, 13, 17, 19];
    for n in n_gram_lengths {
        if n > words.len() {
            continue;
        }
        for i in 0..=words.len() - n {
            tokens.push(words[i..i + n].join(" "));
        }
    }
    tokens
}

fn contains_any_ngram(text: &str, ngrams: &[&str]) -> bool {
    let tokens = extract_tokens(text);
    for ngram in ngrams {
        if tokens.contains(&ngram.to_string()) {
            return true;
        }
    }
    false
}

// New function to check CoderabbitAI communication logs
pub fn check_coderabbitai_comms(crq_id: &str) -> CommsAnalysisResult {
    let comms_path = format!("analysis_data/comms/git/coderabbitai/{}/responses/", crq_id);
    let full_comms_path = std::path::PathBuf::from("/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules/").join(comms_path);

    let mut skipped_review_present = false;
    let mut response_count = 0;
    let mut total_size = 0;
    let mut contains_issue_too_large = false;
    let mut contains_over_quota = false;

    if let Ok(entries) = std::fs::read_dir(&full_comms_path) {
        for entry in entries {
            if let Ok(entry) = entry {
                let path = entry.path();
                if path.is_file() {
                    if let Ok(content) = std::fs::read_to_string(&path) {
                        response_count += 1;
                        total_size += content.as_bytes().len();
                        let lower_content = content.to_lowercase();
                        if lower_content.contains("review skipped") || lower_content.contains("auto reviews are disabled") {
                            skipped_review_present = true;
                        }
                        if lower_content.contains("too large") || lower_content.contains("exceeds size limit") || lower_content.contains("quota") {
                            contains_issue_too_large = true;
                        }
                        if lower_content.contains("rate limit") || lower_content.contains("over quota") || lower_content.contains("wait") || lower_content.contains("try again later") || lower_content.contains("reset time") {
                            contains_over_quota = true;
                        }
                    }
                }
            }
        }
    }

    let meaningful_response_present = response_count >= 2 || total_size >= 5000; // New heuristic

    CommsAnalysisResult {
        skipped_review_present,
        response_count,
        total_size,
        meaningful_response_present,
        contains_issue_too_large,
        contains_over_quota,
    }
}

// New function for Phase 2 actions (Develop, Document, Refactor)
fn classify_phase2_actions(lower_content: &str) -> Option<NextStep> {
    // State: Develop/Implement
    let develop_keywords = ["develop", "implement", "build"];
    let develop_ngrams = [
        "rust code", "gh cli", "code generation", "new sops",
        "crq driven", "driven development", "add crq"
    ];
    if develop_keywords.iter().any(|&k| lower_content.contains(k)) ||
       contains_any_ngram(&lower_content, &develop_ngrams) {
        return Some(NextStep::Develop);
    }

    // State: Document
    let document_keywords = ["document", "sop", "guide"];
    if document_keywords.iter().any(|&k| lower_content.contains(k)) {
        return Some(NextStep::Document);
    }

    // State: Refactor
    let refactor_keywords = ["refactor", "restructure", "improve"];
    if refactor_keywords.iter().any(|&k| lower_content.contains(k)) {
        return Some(NextStep::Refactor);
    }

    None
}

// New function to classify all other states (Phase 2)
pub fn classify_phase2_states(crq_content: &str, crq_id: &str, comms_analysis: &CommsAnalysisResult) -> NextStep {
    let lower_content = crq_content.to_lowercase();
    let content_byte_size = crq_content.as_bytes().len();

    // State 1: ReviewProvided (CoderabbitAI has provided a meaningful review)
    if comms_analysis.meaningful_response_present {
        return NextStep::ReviewProvided;
    }

    // State 2: ReviewSkipped (If skipped and no meaningful response)
    if comms_analysis.skipped_review_present && !comms_analysis.meaningful_response_present {
        return NextStep::ReviewSkipped;
    }

    // State 3: ReviewNeededFromCoderabbitAI (If small and not yet reviewed)
    if content_byte_size < 2500 { // N = 2500 bytes
        return NextStep::ReviewNeededFromCoderabbitAI;
    }

    // State 4: RespondToHuman (Our turn for human attention/decision)
    let respond_to_human_keywords = [
        "clarify", "question", "decision", "feedback", "input", "discuss", "confirm",
        "review", "audit", "verify", "assess", "reflect", "strategic", "conceptual", "architecture", "plan"
    ];
    let respond_to_human_ngrams = [
        "change request", "request quality", "quality crq", "crq document",
        "purpose structure", "lifecycle all", "all other", "other crq", "crq documents",
        "deep dive", "formal qa", "branch as a holistic", "one to one mapping",
        "braindump update", "zos sequence", "open source language", "audited llm",
        "conceptual rust", "concrete lattice", "crq 001 review", "crq 002 automate",
        "submodule report function", "context introspector", "formalize interaction",
        "strategic alignment", "process unification", "gitmodules recon",
        "category theory", "grand unified framework", "dynamic information flow",
        "bott periodicity", "naersk integration", "crq document index",
        "k value type semantics", "lattice and quine", "lattice code generation",
        "llm communication protocol", "meta lattice application", "orchestration layer",
        "recursive decomposition"
    ];
    if respond_to_human_keywords.iter().any(|&k| lower_content.contains(k)) ||
       contains_any_ngram(&lower_content, &respond_to_human_ngrams) {
        return NextStep::RespondToHuman;
    }

    // State 5: Phase 2 Actions (Develop, Document, Refactor)
    if let Some(phase2_action) = classify_phase2_actions(&lower_content) {
        return phase2_action;
    }

    NextStep::Unknown
}

pub fn determine_next_step(crq_content: &str, crq_id: &str) -> NextStep {
    let lower_content = crq_content.to_lowercase();
    let content_byte_size = crq_content.as_bytes().len();

    let comms_analysis = check_coderabbitai_comms(crq_id);

    // Phase 1 States (Highest Priority)

    // State 1: ReviewSkippedDueToSizeLimit (Specific action for size-related skipped review)
    // This requires reading the actual CoderabbitAI response content, which is not directly available here.
    // For now, we'll assume the comms_analysis.contains_issue_too_large is sufficient to trigger this.
    // In a real scenario, we'd pass the actual CoderabbitAI response content to is_review_skipped_due_to_size_limit.
    if comms_analysis.contains_issue_too_large {
        return NextStep::ReviewSkippedDueToSizeLimit;
    }

    // State 2: OverQuota (Immediate action to wait)
    if comms_analysis.contains_over_quota {
        return NextStep::OverQuota;
    }

    // State 3: IssueTooLarge (General action for size, if not specifically skipped due to size limit)
    // This state will now be less specific, as ReviewSkippedDueToSizeLimit handles the specific case.
    if comms_analysis.contains_issue_too_large {
        return NextStep::IssueTooLarge;
    }

    // All other states are Phase 2
    classify_phase2_states(crq_content, crq_id, &comms_analysis)
}

pub fn parse_crq(content: &str) -> Option<Crq> {
    let mut problem_goal = String::new();
    let mut proposed_solution = String::new();
    let mut justification_impact = String::new();

    // Try to extract the main title as the problem_goal
    for line in content.lines() {
        let trimmed_line = line.trim();
        if trimmed_line.starts_with("# CRQ:") || trimmed_line.starts_with("## Change Request:") || trimmed_line.starts_with("**CRQ:") {
            problem_goal = trimmed_line.trim_start_matches("# CRQ:").trim_start_matches("## Change Request:").trim_start_matches("**CRQ:").trim().to_string();
            // Remove markdown formatting from the title
            problem_goal = problem_goal.replace("**", "").trim().to_string();
            break;
        }
    }

    // Fallback if no clear title is found (e.g., use first few lines or filename)
    if problem_goal.is_empty() {
        problem_goal = content.lines().next().unwrap_or("Untitled CRQ").trim().to_string();
        // If it's still a markdown heading, clean it up
        if problem_goal.starts_with('#') {
            problem_goal = problem_goal.trim_start_matches('#').trim().to_string();
        }
    }

    // For now, proposed_solution and justification_impact will remain empty or be filled with a placeholder
    // if no specific sections are found. This can be improved later if needed.
    proposed_solution = "N/A".to_string();
    justification_impact = "N/A".to_string();

    Some(Crq {
        problem_goal,
        proposed_solution,
        justification_impact,
    })
}