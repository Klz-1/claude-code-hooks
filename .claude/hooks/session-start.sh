#!/bin/bash
# SessionStart hook - Detects project capabilities and sets up environment

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/common.sh"
source "$SCRIPT_DIR/utils/detect-project.sh"

# Read hook input
input=$(cat)

# Get session source
source=$(echo "$input" | json_get "source" "unknown")

log_info "Session starting (source: $source)"

# Detect project capabilities
project_info=$(detect_project)

# Extract key information
project_type=$(echo "$project_info" | jq -r '.projectType')
has_ts=$(echo "$project_info" | jq -r '.hasTypeScript')
missing_count=$(echo "$project_info" | jq -r '.missing | length')

# Build context message for Claude
context_parts=()
context_parts+=("Project: $project_type")
if [[ "$has_ts" == "true" ]]; then
    context_parts+=("TypeScript enabled")
fi

# Add available tools
available_tools=()
if has_tool "prettier"; then available_tools+=("prettier"); fi
if has_tool "eslint"; then available_tools+=("eslint"); fi
if has_tool "jest"; then available_tools+=("jest"); fi
if has_tool "vitest"; then available_tools+=("vitest"); fi

if [[ ${#available_tools[@]} -gt 0 ]]; then
    context_parts+=("Tools: ${available_tools[*]}")
fi

# Add available scripts
available_scripts=$(echo "$project_info" | jq -r '.scripts | keys[]' 2>/dev/null | tr '\n' ' ')
if [[ -n "$available_scripts" ]]; then
    context_parts+=("Scripts: $available_scripts")
fi

# Build the context message
context_message="Development environment detected - ${context_parts[*]}"

# If there are missing tools, add suggestions
if [[ $missing_count -gt 0 ]]; then
    log_warning "Missing tools detected: $(get_missing_tools | tr '\n' ' ')"
    log_info "Installation suggestions:"
    get_suggestions | while read suggestion; do
        log_info "  $suggestion"
    done

    # Add to context for Claude
    missing_tools=$(get_missing_tools | tr '\n' ', ')
    context_message="$context_message. Missing recommended tools: $missing_tools"
fi

# Output JSON with additional context for Claude
echo "{
    \"hookSpecificOutput\": {
        \"hookEventName\": \"SessionStart\",
        \"additionalContext\": \"$(json_escape "$context_message")\"
    }
}"

exit 0
