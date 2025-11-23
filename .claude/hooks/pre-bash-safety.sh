#!/bin/bash
# PreToolUse hook for Bash - Blocks dangerous commands

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/common.sh"

# Read hook input
input=$(cat)

# Extract bash command
bash_command=$(echo "$input" | json_get "tool_input.command" "")

# Dangerous command patterns
DANGEROUS_PATTERNS=(
    'rm\s+-rf\s+/'                          # rm -rf /
    'rm\s+-rf\s+~'                          # rm -rf ~
    'rm\s+-rf\s+\*'                         # rm -rf *
    '>\s*/dev/sda'                          # Write to disk device
    'mkfs\.'                                # Format filesystem
    'dd\s+if='                              # Disk operations
    ':(){.*:&};:'                           # Fork bomb
    'wget.*\|\s*bash'                       # Download and execute
    'curl.*\|\s*bash'                       # Download and execute
    'chmod\s+-R\s+777'                      # Overly permissive
    'chown\s+-R\s+.*:\*'                    # Dangerous ownership change
)

# Suspicious patterns that warrant warning but might be legitimate
SUSPICIOUS_PATTERNS=(
    'sudo\s+rm'                             # Sudo with rm
    'git\s+push\s+.*--force'                # Force push
    'npm\s+install.*-g'                     # Global npm install
)

# Check for dangerous patterns
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$bash_command" | grep -qE "$pattern"; then
        log_error "Blocked dangerous command: $bash_command"
        json_deny "PreToolUse" "Dangerous command blocked for safety. Pattern matched: $pattern"
        exit 0
    fi
done

# Check for suspicious patterns
for pattern in "${SUSPICIOUS_PATTERNS[@]}"; do
    if echo "$bash_command" | grep -qE "$pattern"; then
        log_warning "Suspicious command detected: $bash_command"
        # For now, we'll allow but log. Could change to "ask" permission
        json_additional_context "PreToolUse" "Warning: Potentially dangerous command detected. Review before execution."
        exit 0
    fi
done

# Command appears safe
json_allow "PreToolUse"
exit 0
