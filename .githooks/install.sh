#!/bin/bash
# Git Hooks Installation Script
# Installs custom Git hooks for this repository

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Git Hooks Installation${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get git root directory
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [[ -z "$GIT_ROOT" ]]; then
    echo -e "${RED}[ERROR]${NC} Not in a git repository"
    exit 1
fi

HOOKS_DIR="$GIT_ROOT/.githooks"

if [[ ! -d "$HOOKS_DIR" ]]; then
    echo -e "${RED}[ERROR]${NC} .githooks directory not found at: $HOOKS_DIR"
    exit 1
fi

echo -e "${BLUE}[INFO]${NC} Git repository: $GIT_ROOT"
echo -e "${BLUE}[INFO]${NC} Hooks directory: $HOOKS_DIR"
echo ""

# Configure git to use .githooks directory
echo -e "${BLUE}[SETUP]${NC} Configuring Git to use custom hooks directory..."
git config core.hooksPath .githooks

echo -e "${GREEN}[SUCCESS]${NC} Git hooks path configured"
echo ""

# Make all hooks executable
echo -e "${BLUE}[SETUP]${NC} Making hooks executable..."
chmod +x "$HOOKS_DIR"/*

HOOK_COUNT=0
for hook in "$HOOKS_DIR"/*; do
    if [[ -f "$hook" ]] && [[ "$(basename "$hook")" != "install.sh" ]] && [[ "$(basename "$hook")" != "README.md" ]]; then
        echo -e "${GREEN}  ✓${NC} $(basename "$hook")"
        HOOK_COUNT=$((HOOK_COUNT + 1))
    fi
done

echo ""
echo -e "${GREEN}[SUCCESS]${NC} $HOOK_COUNT hook(s) installed and activated"
echo ""

# Show installed hooks
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Installed Hooks${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [[ -f "$HOOKS_DIR/pre-commit" ]]; then
    echo -e "${GREEN}✓ pre-commit${NC}"
    echo "  • Scans for secrets/credentials"
    echo "  • Checks for debug statements"
    echo "  • Validates file sizes"
    echo "  • Runs ESLint on staged files"
    echo "  • Auto-formats with Prettier"
    echo "  • Type-checks TypeScript"
    echo "  • Detects merge conflicts"
    echo ""
fi

if [[ -f "$HOOKS_DIR/commit-msg" ]]; then
    echo -e "${GREEN}✓ commit-msg${NC}"
    echo "  • Validates commit message length"
    echo "  • Checks message format"
    echo "  • Adds branch references"
    echo ""
fi

if [[ -f "$HOOKS_DIR/pre-push" ]]; then
    echo -e "${GREEN}✓ pre-push${NC}"
    echo "  • Prevents force push to main/master"
    echo "  • Runs full test suite"
    echo "  • Verifies build succeeds"
    echo "  • Checks for WIP commits"
    echo "  • Validates branch is up to date"
    echo ""
fi

if [[ -f "$HOOKS_DIR/post-checkout" ]]; then
    echo -e "${GREEN}✓ post-checkout${NC}"
    echo "  • Shows branch status"
    echo "  • Warns on protected branches"
    echo "  • Displays uncommitted changes"
    echo "  • Detects dependency changes"
    echo ""
fi

if [[ -f "$HOOKS_DIR/post-merge" ]]; then
    echo -e "${GREEN}✓ post-merge${NC}"
    echo "  • Auto-installs dependencies"
    echo "  • Cleans build artifacts"
    echo "  • Detects migration changes"
    echo "  • Updates .env warnings"
    echo ""
fi

if [[ -f "$HOOKS_DIR/pre-rebase" ]]; then
    echo -e "${GREEN}✓ pre-rebase${NC}"
    echo "  • Prevents rebasing protected branches"
    echo "  • Warns on public commits"
    echo "  • Ensures clean working directory"
    echo ""
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✓ Git hooks are now active!${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "  • Hooks will run automatically on git operations"
echo "  • Use --no-verify to bypass hooks (not recommended)"
echo "  • Check .githooks/README.md for customization"
echo ""
echo -e "${YELLOW}Note:${NC} Team members should run this after cloning:"
echo "  ${BLUE}bash .githooks/install.sh${NC}"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
