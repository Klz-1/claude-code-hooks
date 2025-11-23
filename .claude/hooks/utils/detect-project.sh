#!/bin/bash
# Project detection utility - detects tools, capabilities, and suggests missing dependencies

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Cache file for detection results (speeds up subsequent calls)
CACHE_FILE="/tmp/claude-hooks-cache-$$.json"

# Detect project type and available tools
detect_project() {
    local project_root=$(get_project_root)

    # Initialize detection result
    local result='{
        "projectType": "unknown",
        "hasPackageJson": false,
        "hasTypeScript": false,
        "tools": {
            "prettier": false,
            "eslint": false,
            "jest": false,
            "vitest": false,
            "tsc": false
        },
        "scripts": {},
        "missing": [],
        "suggestions": []
    }'

    # Check for package.json
    if [[ -f "$project_root/package.json" ]]; then
        result=$(echo "$result" | jq '.hasPackageJson = true')

        # Detect project type from package.json
        if jq -e '.dependencies."next" // .devDependencies."next"' "$project_root/package.json" >/dev/null 2>&1; then
            result=$(echo "$result" | jq '.projectType = "nextjs"')
        elif jq -e '.dependencies."react" // .devDependencies."react"' "$project_root/package.json" >/dev/null 2>&1; then
            result=$(echo "$result" | jq '.projectType = "react"')
        elif jq -e '.dependencies."vue" // .devDependencies."vue"' "$project_root/package.json" >/dev/null 2>&1; then
            result=$(echo "$result" | jq '.projectType = "vue"')
        elif jq -e '.dependencies."express" // .devDependencies."express"' "$project_root/package.json" >/dev/null 2>&1; then
            result=$(echo "$result" | jq '.projectType = "node"')
        else
            result=$(echo "$result" | jq '.projectType = "javascript"')
        fi

        # Check for TypeScript
        if [[ -f "$project_root/tsconfig.json" ]] || has_npm_package "typescript"; then
            result=$(echo "$result" | jq '.hasTypeScript = true')
        fi

        # Detect available tools
        if has_npm_package "prettier"; then
            result=$(echo "$result" | jq '.tools.prettier = true')
        else
            result=$(echo "$result" | jq '.missing += ["prettier"]')
            result=$(echo "$result" | jq '.suggestions += ["npm install --save-dev prettier"]')
        fi

        if has_npm_package "eslint"; then
            result=$(echo "$result" | jq '.tools.eslint = true')
        else
            result=$(echo "$result" | jq '.missing += ["eslint"]')
            result=$(echo "$result" | jq '.suggestions += ["npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin"]')
        fi

        if has_npm_package "jest"; then
            result=$(echo "$result" | jq '.tools.jest = true')
        elif has_npm_package "vitest"; then
            result=$(echo "$result" | jq '.tools.vitest = true')
        else
            result=$(echo "$result" | jq '.missing += ["test-runner"]')
            result=$(echo "$result" | jq '.suggestions += ["npm install --save-dev jest ts-jest @types/jest"]')
        fi

        if has_npm_package "typescript"; then
            result=$(echo "$result" | jq '.tools.tsc = true')
        fi

        # Extract available npm scripts
        local scripts=$(jq -r '.scripts // {} | keys[]' "$project_root/package.json" 2>/dev/null)
        if [[ -n "$scripts" ]]; then
            while IFS= read -r script; do
                result=$(echo "$result" | jq ".scripts.\"$script\" = true")
            done <<< "$scripts"
        fi
    fi

    # Cache the result
    echo "$result" > "$CACHE_FILE"
    echo "$result"
}

# Get cached detection or run fresh detection
get_project_info() {
    if [[ -f "$CACHE_FILE" ]]; then
        cat "$CACHE_FILE"
    else
        detect_project
    fi
}

# Check if a specific tool is available
has_tool() {
    local tool="$1"
    local info=$(get_project_info)
    echo "$info" | jq -r ".tools.\"$tool\"" | grep -q "true"
}

# Check if a script is available
has_script() {
    local script="$1"
    local info=$(get_project_info)
    echo "$info" | jq -r ".scripts.\"$script\"" | grep -q "true"
}

# Get missing tools
get_missing_tools() {
    local info=$(get_project_info)
    echo "$info" | jq -r '.missing[]' 2>/dev/null
}

# Get installation suggestions
get_suggestions() {
    local info=$(get_project_info)
    echo "$info" | jq -r '.suggestions[]' 2>/dev/null
}

# Print project capabilities (for debugging)
print_capabilities() {
    local info=$(get_project_info)
    log_info "Project Type: $(echo "$info" | jq -r '.projectType')"
    log_info "Has TypeScript: $(echo "$info" | jq -r '.hasTypeScript')"
    log_info "Available Tools:"
    echo "$info" | jq -r '.tools | to_entries[] | "  - \(.key): \(.value)"' >&2

    if [[ $(echo "$info" | jq -r '.missing | length') -gt 0 ]]; then
        log_warning "Missing Tools:"
        echo "$info" | jq -r '.missing[]' | while read tool; do
            echo "  - $tool" >&2
        done

        log_info "Installation Suggestions:"
        get_suggestions | while read suggestion; do
            echo "  $suggestion" >&2
        done
    fi
}

# If run directly, print capabilities
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    print_capabilities
fi
