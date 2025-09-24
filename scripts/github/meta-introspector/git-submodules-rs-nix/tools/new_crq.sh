#!/usr/bin/env bash

# This script helps create a new CRQ file with a standard template.

CRQ_TITLE="$1"

if [ -z "$CRQ_TITLE" ]; then
  echo "Usage: $0 \"<CRQ Title>\""
  echo "Example: $0 \"Implement User Authentication Module\""
  exit 1
fi

# Sanitize title for filename
FILENAME=$(echo "$CRQ_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_ -]//g' | sed 's/ /-/g' | sed 's/--/-/g')

# Determine the next CRQ number
LAST_CRQ_NUM=$(printf '%s
' docs/crq_standardized/CRQ-*-*.md 2>/dev/null | grep -oP 'CRQ-\K\d+' | sort -n | tail -n 1)
NEXT_CRQ_NUM=$((LAST_CRQ_NUM + 1))
CRQ_NUMBER=$(printf "%03d" "$NEXT_CRQ_NUM") # Format as 001, 002, etc.

NEW_CRQ_FILENAME="CRQ-${CRQ_NUMBER}-${FILENAME}.md"
NEW_CRQ_PATH="docs/crq_standardized/${NEW_CRQ_FILENAME}"

if [ -f "$NEW_CRQ_PATH" ]; then
  echo "Error: CRQ file already exists: $NEW_CRQ_PATH"
  exit 1
fi

echo "Creating new CRQ: $NEW_CRQ_PATH"

cat << EOF > "$NEW_CRQ_PATH"
**CRQ: ${CRQ_TITLE}**

**Problem/Goal:**
[Describe the problem or goal this CRQ aims to address.]

**Proposed Solution:**
[Outline the proposed solution or approach to achieve the goal.]

**Justification/Impact:**
[Explain why this CRQ is important, its benefits, and potential impact on the project.]
EOF

echo "New CRQ created successfully."
echo "Please edit the file: $NEW_CRQ_PATH"
