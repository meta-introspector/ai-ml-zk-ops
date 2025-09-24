#!/bin/bash
#
# Filename: generate_repo_2gram_csv.sh
# Description: This script automates the 2-gram analysis of repository names
#              extracted from file paths within the project. It uses an AWK script
#              to identify owner/repo pairs from paths, counts their frequencies,
#              and outputs the top 80 results in CSV format.
#
# Usage:
#   ./generate_repo_2gram_csv.sh
#
# Output:
#   A CSV file named '2gram.csv' in the project root directory, containing
#   the top 80 most frequent repository 2-grams (Count,Owner,Repo).
#
# Dependencies:
#   - awk (specifically, the repo_2gram_analysis.awk script located in the same directory)
#   - sort utility
#   - head utility
#   - files.txt (located in the project root, containing a list of file paths)
#
# Nix Flakes Context:
#   This script is designed to support the Nixification workflow by providing insights
#   into the most commonly referenced external GitHub repositories within the project's
#   file structure. This information can be crucial for optimizing flake inputs,
#   managing vendored dependencies, and understanding the overall dependency graph
#   of the project in a Nix-centric environment. The analysis helps in identifying
#   potential areas for consolidation or further Nix-specific optimization.
#

# Determine the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Define paths relative to the script's location
AWK_SCRIPT="${SCRIPT_DIR}/repo_2gram_analysis.awk"
FILES_TXT="${SCRIPT_DIR}/../../files.txt"
OUTPUT_CSV="${SCRIPT_DIR}/../../2gram.csv"

# Check if the input files exist
if [ ! -f "$AWK_SCRIPT" ]; then
  echo "Error: AWK script not found at $AWK_SCRIPT"
  exit 1
fi

if [ ! -f "$FILES_TXT" ]; then
  echo "Error: files.txt not found at $FILES_TXT"
  exit 1
fi

# Execute the AWK script, sort the output, and save the top 80 results to CSV
awk -f "$AWK_SCRIPT" "$FILES_TXT" | sort -t',' -rn -k1,1 | head -n 80 > "$OUTPUT_CSV"

echo "Repository 2-gram analysis saved to $OUTPUT_CSV"
