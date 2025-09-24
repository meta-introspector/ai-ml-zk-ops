#!/usr/bin/env bash

# Test 1: Call tiktok_banner.sh with a message

SCRIPT_TO_TEST="/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/streamofrandom/scripts/tiktok_banner.sh"
TEST_NAME="Test 1: Calling with a message"
TEST_STATUS=0

echo "--- $TEST_NAME ---"

# Check if figlet is installed in the test environment
if command -v figlet &> /dev/null
then
  FIGLET_INSTALLED=true
  echo "figlet is installed. Proceeding with output check."
else
  FIGLET_INSTALLED=false
  echo "figlet is NOT installed. Skipping output check."
fi

if [ "$FIGLET_INSTALLED" = true ]; then
  OUTPUT=$("$SCRIPT_TO_TEST" "Hello Test")
  if [ -n "$OUTPUT" ]; then
    echo "$TEST_NAME: SUCCESS - Non-empty output produced."
  else
    echo "$TEST_NAME: FAILED - Empty output produced."
    TEST_STATUS=1
  fi
else
  echo "$TEST_NAME: SKIPPED (figlet not installed)."
fi

exit $TEST_STATUS
