#!/usr/bin/env bash

# Simple script to extract 2-grams from input text
# Reads from stdin, outputs 2-grams to stdout

text=$(cat)

# Convert text to lowercase, replace non-alphanumeric with spaces, and then split into words
words=$(echo "$text" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 ]/ /g' | tr -s ' ')

# Extract 2-grams
read -ra word_array <<< "$words"

for (( i=0; i<${#word_array[@]}-1; i++ )); do
  echo "${word_array[i]} ${word_array[i+1]}"
done
