#!/usr/bin/env bash

# Orchestrates the execution of modular tests for tiktok_banner.sh

TEST_DIR="/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/streamofrandom/scripts/tests/"
OVERALL_TEST_STATUS=0

echo "--- Running all tests for tiktok_banner.sh ---"
echo ""

# Iterate through scripts in tests/ and execute them
for test_script in "$TEST_DIR"/*.sh; do
    if [ -f "$test_script" ]; then
        bash "$test_script"
        SCRIPT_STATUS=$?
        if [ ${SCRIPT_STATUS} -ne 0 ]; then
            echo "Test $(basename "$test_script") FAILED (Exit Code: ${SCRIPT_STATUS})"
            OVERALL_TEST_STATUS=$((OVERALL_TEST_STATUS + SCRIPT_STATUS))
        else
            echo "Test $(basename "$test_script") SUCCESS"
        fi
        echo ""
    fi
done

if [ ${OVERALL_TEST_STATUS} -eq 0 ]; then
    echo "--- All tests passed ---"
else
    echo "--- Some tests FAILED. Overall Exit Code: ${OVERALL_TEST_STATUS} ---"
fi

exit ${OVERALL_TEST_STATUS}