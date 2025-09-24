#!/usr/bin/env bash
set -x # Enable debugging

# This script centralizes logging to the social_media_fiber_log.md,
# ensuring date-based directory creation and non-overwriting.

# Usage: log_to_fiber.sh "<log_message>" "<log_type>"

LOG_MESSAGE="$1"
LOG_TYPE="$2" # e.g., "Grokai Request", "Bug Report", "Tweet Confirmation" 

if [ -z "$LOG_MESSAGE" ] || [ -z "$LOG_TYPE" ]; then
  echo "Usage: $0 \"<log_message>\" \"<log_type>\""
  exit 1
fi

STREAMOFRANDOM_BASE_PATH="/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/streamofrandom"
CURRENT_YEAR=$(date +"%Y")
CURRENT_MONTH=$(date +"%m")
CURRENT_DAY=$(date +"%d")
DATE_DIR="$STREAMOFRANDOM_BASE_PATH/$CURRENT_YEAR/$CURRENT_MONTH/$CURRENT_DAY"

# Ensure log directory exists
mkdir -p "$DATE_DIR"

LOG_FILE="$DATE_DIR/social_media_fiber_log.md"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

cat << EOF >> "$LOG_FILE"
## $TIMESTAMP - $LOG_TYPE

```
$LOG_MESSAGE
```

EOF

echo "Log entry added to $LOG_FILE"


