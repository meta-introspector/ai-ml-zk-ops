#!/usr/bin/env bash

# Script to test Magit loading within the Nix-built Emacs environment.
# Corresponds to SOP step 3.3: Test Magit Loading.

EMACS_CONFIG_DIR="/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules/.emacs.d/terlar-emacs-config"
EMACS_BATCH_TEST_SCRIPT="$EMACS_CONFIG_DIR/submodule/run_emacs_batch_test.sh"

echo "Running existing Emacs batch test script..."
if "$EMACS_BATCH_TEST_SCRIPT"; then
    echo "Existing Emacs batch test PASSED."
else
    echo "Existing Emacs batch test FAILED. See output above."
fi

echo ""
echo "Running custom Magit loading test..."

# Create a temporary Emacs Lisp file to test Magit loading
MAGIT_TEST_EL=$(mktemp /tmp/magit-test-XXXX.el)

cat <<EOF > "$MAGIT_TEST_EL"
(require 'magit)
(message "Magit loaded successfully!")
(if (fboundp 'magit-status)
    (message "magit-status function is available.")
  (error "magit-status function is NOT available."))
EOF

# Run Emacs in batch mode with the custom test file
# We need to ensure the Nix environment is loaded for this.
# The 'nix develop' command will set up the environment.
cd "$EMACS_CONFIG_DIR" || { echo "Error: Could not change to Emacs config directory."; exit 1; }

nix develop --command emacs --batch -l "$MAGIT_TEST_EL"

TEST_EXIT_CODE=$?

if [ $TEST_EXIT_CODE -eq 0 ]; then
  echo "Custom Magit loading test PASSED."
else
  echo "Custom Magit loading test FAILED with exit code $TEST_EXIT_CODE."
fi

# Clean up the temporary file
rm "$MAGIT_TEST_EL"

exit $TEST_EXIT_CODE
