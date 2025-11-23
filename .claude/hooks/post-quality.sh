#!/bin/bash
# PostToolUse hook - Runs quality checks (formatting, linting) after file modifications

# Get script directory and source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/common.sh"
source "$SCRIPT_DIR/utils/detect-project.sh"

# Read hook input
input=$(cat)

# Extract tool information
tool_name=$(echo "$input" | json_get "tool_name" "unknown")
file_path=$(echo "$input" | json_get "tool_input.file_path" "")

# If no file_path, try path
if [[ -z "$file_path" || "$file_path" == "null" ]]; then
    file_path=$(echo "$input" | json_get "tool_input.path" "")
fi

# Skip if no file path (shouldn't happen for Write/Edit)
if [[ -z "$file_path" || "$file_path" == "null" ]]; then
    json_additional_context "PostToolUse" "No file path found in tool input"
    exit 0
fi

# Skip if file doesn't exist
if [[ ! -f "$file_path" ]]; then
    log_warning "File not found: $file_path"
    exit 0
fi

project_root=$(get_project_root)
log_info "Running quality checks on: $file_path"

# Track what was done
actions_taken=()
errors=()

# --- Prettier formatting ---
if has_tool "prettier"; then
    log_info "Running Prettier..."
    cd "$project_root"

    if prettier --write "$file_path" 2>/dev/null; then
        actions_taken+=("formatted with Prettier")
        log_success "Prettier formatting applied"
    else
        prettier_error=$(prettier --write "$file_path" 2>&1)
        errors+=("Prettier failed: $prettier_error")
        log_error "Prettier failed: $prettier_error"
    fi
elif [[ $(get_missing_tools | grep -c "prettier") -gt 0 ]]; then
    log_warning "Prettier not installed. Run: npm install --save-dev prettier"
fi

# --- ESLint ---
if has_tool "eslint"; then
    # Only lint JS/TS files
    if is_file_type "$file_path" "js" "jsx" "ts" "tsx"; then
        log_info "Running ESLint..."
        cd "$project_root"

        # Try to fix automatically
        if npx eslint --fix "$file_path" 2>/dev/null; then
            actions_taken+=("linted with ESLint")
            log_success "ESLint checks passed"
        else
            eslint_error=$(npx eslint "$file_path" 2>&1)

            # Check if it's just warnings or actual errors
            if echo "$eslint_error" | grep -q "error"; then
                errors+=("ESLint errors found")
                log_error "ESLint found errors:"
                echo "$eslint_error" >&2
            else
                actions_taken+=("linted with ESLint (with warnings)")
                log_warning "ESLint found warnings"
            fi
        fi
    fi
elif [[ $(get_missing_tools | grep -c "eslint") -gt 0 ]]; then
    log_warning "ESLint not installed. Run: npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin"
fi

# --- TypeScript type checking (if TS file) ---
if has_tool "tsc" && is_file_type "$file_path" "ts" "tsx"; then
    log_info "Running TypeScript type check..."
    cd "$project_root"

    if npx tsc --noEmit 2>/dev/null; then
        actions_taken+=("type-checked with TSC")
        log_success "TypeScript type check passed"
    else
        tsc_error=$(npx tsc --noEmit 2>&1 | head -20)
        errors+=("TypeScript type errors found")
        log_error "TypeScript errors:"
        echo "$tsc_error" >&2
    fi
fi

# --- Build output ---
if [[ ${#errors[@]} -gt 0 ]]; then
    # If there are errors, block with detailed message
    error_message="Quality checks failed:\\n"
    for error in "${errors[@]}"; do
        error_message+="- $error\\n"
    done
    error_message+="\\nPlease fix these issues before proceeding."

    log_error "Quality checks failed. Blocking operation."
    json_block "$(echo -e "$error_message")"
    exit 0
else
    # Success - report what was done
    if [[ ${#actions_taken[@]} -gt 0 ]]; then
        action_message="Quality checks passed: ${actions_taken[*]}"
        log_success "$action_message"
        json_additional_context "PostToolUse" "$action_message"
    else
        json_additional_context "PostToolUse" "No quality tools available for this file type"
    fi
    exit 0
fi
