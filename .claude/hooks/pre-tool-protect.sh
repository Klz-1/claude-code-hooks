#!/bin/bash
# PreToolUse hook - Protects sensitive files and validates file operations

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/common.sh"

# Read hook input
input=$(cat)

# Extract tool information
tool_name=$(echo "$input" | json_get "tool_name" "unknown")
file_path=$(echo "$input" | json_get "tool_input.file_path" "")

# If no file_path, try path (Write tool uses file_path, Edit uses file_path)
if [[ -z "$file_path" || "$file_path" == "null" ]]; then
    file_path=$(echo "$input" | json_get "tool_input.path" "")
fi

# Protected file patterns (regex)
PROTECTED_PATTERNS=(
    '\.env$'
    '\.env\.local$'
    '\.env\.production$'
    '\.env\.development$'
    'credentials\.json$'
    'secrets\.json$'
    '\.secret$'
    '\.key$'
    '\.pem$'
    '\.p12$'
    'private[_-]key'
    'aws[_-]credentials'
    '\.npmrc$'
    '\.pypirc$'
)

# Check if file matches any protected pattern
for pattern in "${PROTECTED_PATTERNS[@]}"; do
    if path_matches_pattern "$file_path" "$pattern"; then
        log_error "Blocked: Cannot modify protected file: $file_path"
        json_deny "PreToolUse" "Cannot modify sensitive files (.env, credentials, keys). This file appears to contain secrets."
        exit 0
    fi
done

# All checks passed - allow the operation
json_allow "PreToolUse"
exit 0
