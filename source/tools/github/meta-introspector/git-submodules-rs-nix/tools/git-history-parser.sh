#!/bin/bash

# This script parses Git history into a JSON format.
# It's a preliminary step for the Context Introspector's Git Parser component.

# Check if git is installed
if ! command -v git &> /dev/null
then
    echo "Error: git is not installed. Please install git to use this script."
    exit 1
fi

# Get the root of the git repository
GIT_ROOT=$(git rev-parse --show-toplevel)
if [ -z "$GIT_ROOT" ]; then
    echo "Error: Not in a git repository."
    exit 1
fi

cd "$GIT_ROOT" || exit

# Initialize JSON array
echo "["

# Loop through each commit
git log --pretty=format:'%H%n%an%n%ae%n%ad%n%s%n%b%n---FILES---' --numstat --date=iso-strict | while IFS= read -r line; do
    if [[ "$line" == "---FILES---" ]]; then
        # End of commit metadata, start of files
        # Read file stats until empty line or end of input
        files_json=""
        while IFS= read -r file_line && [[ -n "$file_line" ]]; do
            read -r added removed filename <<< "$file_line"
            files_json+="{\"added\": \"$added\", \"removed\": \"$removed\", \"filename\": \"$filename\"},"
        done
        # Remove trailing comma
        files_json="${files_json%,}"
        echo "      \"files\": [$files_json]"
        echo "    },"
    elif [[ "$line" =~ ^[0-9a-f]{40}$ ]]; then
        # Commit hash
        if [[ $first_commit -eq 0 ]]; then
            echo "    {"
        else
            echo "" # No comma for the first object
        fi
        first_commit=1
        echo "      \"hash\": \"$line\","
    elif [[ "$line" =~ ^Author:\ (.*)$ ]]; then
        # Author name
        echo "      \"author_name\": \"${BASH_REMATCH[1]}\","
    elif [[ "$line" =~ ^AuthorDate:\ (.*)$ ]]; then
        # Author email
        echo "      \"author_email\": \"${BASH_REMATCH[1]}\","
    elif [[ "$line" =~ ^Date:\ (.*)$ ]]; then
        # Commit date
        echo "      \"date\": \"${BASH_REMATCH[1]}\","
    elif [[ "$line" =~ ^Subject:\ (.*)$ ]]; then
        # Subject (first line of commit message)
        echo "      \"subject\": \"${BASH_REMATCH[1]}\""
    elif [[ "$line" =~ ^Body:\ (.*)$ ]]; then
        # Body (rest of commit message)
        echo "      \"body\": \"${BASH_REMATCH[1]}\""
    fi
done

# Remove trailing comma from the last object and close array
echo "]" | sed '$s/,//'