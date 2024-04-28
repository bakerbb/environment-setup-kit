#!/bin/bash

set -euo pipefail  # Enable strict mode for better error handling

# Function to display help information
display_help() {
    echo "Usage: $0 [--help] <file1> [file2] [...]"
    echo "Options:"
    echo "  --help    Display this help message and exit"
    echo "Purpose:"
    echo "  This script processes each specified file to:"
    echo "  1. Convert Windows-style carriage returns (CR) to Unix-style line feeds (LF)."
    echo "  2. Remove trailing whitespace from each line."
    echo "  3. Replace sequences of three or more consecutive newlines with exactly two newlines."
    echo "It is designed to work with BSD sed, as commonly found on macOS."
}

# Check for the help option or if no file path is provided
if [ "$#" -eq 0 ] || [[ "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Function to process a single file
process_file() {
    local file="$1"

    # Check if the file exists
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist."
        return 1
    fi

    # Convert newline characters to Unix style (LF)
    sed -i '' -E 's/\r$//' "$file"

    # Remove trailing whitespace
    sed -i '' -E 's/[[:blank:]]+$//' "$file"

    # Replace three or more consecutive newlines with two newlines using Perl
    perl -i -0777 -pe 's/\n{3,}/\n\n/g' "$file"
}

# Process each file passed as an argument
for file in "$@"; do
    process_file "$file"
done
