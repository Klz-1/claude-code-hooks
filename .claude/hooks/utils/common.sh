#!/bin/bash
# Common utility functions for Claude Code hooks

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# JSON output helpers
json_allow() {
    echo '{"hookSpecificOutput": {"hookEventName": "'"$1"'", "permissionDecision": "allow"}}'
}

json_deny() {
    local event="$1"
    local reason="$2"
    echo '{"hookSpecificOutput": {"hookEventName": "'"$event"'", "permissionDecision": "deny", "permissionDecisionReason": "'"$reason"'"}}'
}

json_block() {
    local reason="$1"
    echo '{"decision": "block", "reason": "'"$reason"'"}'
}

json_system_message() {
    local message="$1"
    echo '{"systemMessage": "'"$message"'"}'
}

json_additional_context() {
    local event="$1"
    local context="$2"
    echo '{"hookSpecificOutput": {"hookEventName": "'"$event"'", "additionalContext": "'"$context"'"}}'
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if we're in a git repository
is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

# Get project root (git root or CLAUDE_PROJECT_DIR)
get_project_root() {
    if [[ -n "$CLAUDE_PROJECT_DIR" ]]; then
        echo "$CLAUDE_PROJECT_DIR"
    elif is_git_repo; then
        git rev-parse --show-toplevel 2>/dev/null
    else
        pwd
    fi
}

# Check if file exists in project
file_exists() {
    local file="$1"
    local project_root=$(get_project_root)
    [[ -f "$project_root/$file" ]]
}

# Read JSON value from stdin using jq
json_get() {
    local key="$1"
    local default="${2:-empty}"
    jq -r ".$key // \"$default\""
}

# Check if npm script exists
has_npm_script() {
    local script_name="$1"
    local project_root=$(get_project_root)

    if [[ ! -f "$project_root/package.json" ]]; then
        return 1
    fi

    jq -e ".scripts.\"$script_name\"" "$project_root/package.json" >/dev/null 2>&1
}

# Check if npm package is installed
has_npm_package() {
    local package_name="$1"
    local project_root=$(get_project_root)

    if [[ ! -f "$project_root/package.json" ]]; then
        return 1
    fi

    jq -e ".devDependencies.\"$package_name\" // .dependencies.\"$package_name\"" "$project_root/package.json" >/dev/null 2>&1
}

# Run npm script if it exists
run_npm_script() {
    local script_name="$1"
    local project_root=$(get_project_root)

    if has_npm_script "$script_name"; then
        cd "$project_root" && npm run "$script_name" 2>&1
        return $?
    else
        return 1
    fi
}

# Check if path matches pattern (for file protection)
path_matches_pattern() {
    local path="$1"
    local pattern="$2"
    echo "$path" | grep -E "$pattern" >/dev/null 2>&1
}

# Escape special characters for JSON
json_escape() {
    local str="$1"
    # Escape backslashes, quotes, and newlines (portable version)
    printf '%s' "$str" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' '
}

# Get file extension
get_extension() {
    local filepath="$1"
    echo "${filepath##*.}"
}

# Check if file is a specific type
is_file_type() {
    local filepath="$1"
    shift
    local extensions=("$@")
    local file_ext=$(get_extension "$filepath")

    for ext in "${extensions[@]}"; do
        if [[ "$file_ext" == "$ext" ]]; then
            return 0
        fi
    done
    return 1
}
