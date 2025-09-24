pub struct Crq {
    pub problem_goal: String,
    pub proposed_solution: String,
    pub justification_impact: String,
}

pub enum NextStep {
    Develop,
    Refactor,
    Document,
    Unknown,
}

pub fn determine_next_step(crq_content: &str) -> NextStep {
    let lower_content = crq_content.to_lowercase();

    if lower_content.contains("develop") || lower_content.contains("implement") || lower_content.contains("build") {
        NextStep::Develop
    } else if lower_content.contains("refactor") || lower_content.contains("restructure") || lower_content.contains("improve") {
        NextStep::Refactor
    } else if lower_content.contains("document") || lower_content.contains("sop") || lower_content.contains("guide") {
        NextStep::Document
    } else {
        NextStep::Unknown
    }
}

// A very basic parser for now. This will need to be more robust.
pub fn parse_crq(content: &str) -> Option<Crq> {
    let mut problem_goal = String::new();
    let mut proposed_solution = String::new();
    let mut justification_impact = String::new();

    let lines: Vec<&str> = content.lines().collect();
    let mut current_section = "";

    for line in lines {
        if line.starts_with("**Problem/Goal:**") {
            current_section = "problem_goal";
            problem_goal = line.replace("**Problem/Goal:**", "").trim().to_string();
        } else if line.starts_with("**Proposed Solution:**") {
            current_section = "proposed_solution";
            proposed_solution = line.replace("**Proposed Solution:**", "").trim().to_string();
        } else if line.starts_with("**Justification/Impact:**") {
            current_section = "justification_impact";
            justification_impact = line.replace("**Justification/Impact:**", "").trim().to_string();
        } else {
            match current_section {
                "problem_goal" => {
                    if problem_goal.is_empty() {
                        problem_goal = line.trim().to_string();
                    } else {
                        problem_goal.push_str(&format!("\n{}", line.trim()));
                    }
                },
                "proposed_solution" => {
                    if proposed_solution.is_empty() {
                        proposed_solution = line.trim().to_string();
                    } else {
                        proposed_solution.push_str(&format!("\n{}", line.trim()));
                    }
                },
                "justification_impact" => {
                    if justification_impact.is_empty() {
                        justification_impact = line.trim().to_string();
                    } else {
                        justification_impact.push_str(&format!("\n{}", line.trim()));
                    }
                },
                _ => {},
            }
        }
    }

    if !problem_goal.is_empty() && !proposed_solution.is_empty() && !justification_impact.is_empty() {
        Some(Crq {
            problem_goal,
            proposed_solution,
            justification_impact,
        })
    } else {
        None
    }
}
