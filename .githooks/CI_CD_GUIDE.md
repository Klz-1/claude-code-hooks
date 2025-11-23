# Git Hooks in CI/CD and Automated Workflows

## Problem: Interactive Prompts Block Automation

Git hooks with interactive prompts (like "Are you sure? [y/N]") break:

- ✗ CI/CD pipelines
- ✗ Automated deployment scripts
- ✗ Claude Code operations
- ✗ Any non-interactive environment

## Solution: Environment Variable Overrides

The hooks detect non-interactive mode and check for environment variables to allow operations.

---

## 🔍 How It Works

### Detection Logic

Hooks automatically detect non-interactive mode by checking:

1. `test -t 0` - Is stdin a terminal?
2. `$CI` - Generic CI environment variable
3. `$GITHUB_ACTIONS` - GitHub Actions
4. `$GITLAB_CI` - GitLab CI

### Behavior in Non-Interactive Mode

**Without environment variables:**

```bash
[BLOCKED] Cannot push to main in non-interactive mode
           Set ALLOW_MAIN_PUSH=1 to override or use --no-verify
```

**With environment variables:**

```bash
[ALLOWED] Non-interactive mode with ALLOW_MAIN_PUSH=1
```

---

## 🎯 Environment Variables

### ALLOW_MAIN_PUSH

**Purpose:** Allow pushing to main/master branch in non-interactive mode

**Use case:** CI/CD deployments to production

**Example:**

```bash
# In your script
export ALLOW_MAIN_PUSH=1
git push origin main

# One-liner
ALLOW_MAIN_PUSH=1 git push origin main
```

**GitHub Actions:**

```yaml
- name: Deploy to main
  env:
    ALLOW_MAIN_PUSH: 1
  run: git push origin main
```

---

### ALLOW_FORCE_PUSH

**Purpose:** Allow force push in non-interactive mode

**Use case:** Automated branch cleanup, rebases in CI

**Example:**

```bash
export ALLOW_FORCE_PUSH=1
git push --force origin feature-branch

# One-liner
ALLOW_FORCE_PUSH=1 git push --force origin feature-branch
```

---

### ALLOW_PROTECTED_PUSH

**Purpose:** Alias for ALLOW_MAIN_PUSH

**Use case:** Generic protected branch pushes

**Example:**

```bash
ALLOW_PROTECTED_PUSH=1 git push origin main
```

---

### ALLOW_REBASE_MAIN

**Purpose:** Allow rebasing onto main/master

**Use case:** Automated branch updates

**Example:**

```bash
ALLOW_REBASE_MAIN=1 git rebase main
```

---

### ALLOW_REBASE_PUBLIC

**Purpose:** Allow rebasing published commits

**Use case:** Automated history cleanup

**Example:**

```bash
ALLOW_REBASE_PUBLIC=1 git rebase -i HEAD~5
```

---

## 📋 Common Scenarios

### Scenario 1: GitHub Actions Deploy

```yaml
name: Deploy to Production

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Build
        run: npm run build

      - name: Deploy to main
        env:
          ALLOW_MAIN_PUSH: 1
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add dist/
          git commit -m "Deploy ${{ github.ref_name }}"
          git push origin main
```

---

### Scenario 2: GitLab CI Deployment

```yaml
deploy:
  stage: deploy
  script:
    - npm run build
    - git add dist/
    - git commit -m "Deploy ${CI_COMMIT_TAG}"
    - ALLOW_MAIN_PUSH=1 git push origin main
  only:
    - tags
```

---

### Scenario 3: Claude Code Automated Push

```bash
# In Claude Code session
export ALLOW_MAIN_PUSH=1
git push origin main
```

---

### Scenario 4: Deployment Script

```bash
#!/bin/bash
# deploy.sh

set -e

echo "Building project..."
npm run build

echo "Committing build artifacts..."
git add dist/
git commit -m "Production build $(date +%Y-%m-%d)"

echo "Deploying to main..."
ALLOW_MAIN_PUSH=1 git push origin main

echo "✓ Deployment complete"
```

Usage:

```bash
bash deploy.sh
```

---

### Scenario 5: Force Update Feature Branch (CI)

```yaml
rebase-feature:
  script:
    - git fetch origin main
    - ALLOW_REBASE_PUBLIC=1 git rebase origin/main
    - ALLOW_FORCE_PUSH=1 git push --force origin $CI_COMMIT_REF_NAME
```

---

## 🚫 When NOT to Use

### Don't Use in Interactive Development

```bash
# ❌ BAD: In your local shell
export ALLOW_MAIN_PUSH=1  # Now ALL pushes bypass checks!

# ✓ GOOD: One-time for specific command
ALLOW_MAIN_PUSH=1 git push origin main
```

### Don't Disable All Protections

```bash
# ❌ BAD: Disabling all safety
export ALLOW_MAIN_PUSH=1
export ALLOW_FORCE_PUSH=1
export ALLOW_REBASE_MAIN=1
export ALLOW_REBASE_PUBLIC=1

# ✓ GOOD: Use --no-verify if you really need to bypass
git push --no-verify
```

---

## 🔐 Security Best Practices

### 1. Limit Scope

Use environment variables only in CI/CD:

```yaml
# GitHub Actions
deploy:
  environment: production # Requires manual approval
  env:
    ALLOW_MAIN_PUSH: 1
```

### 2. Audit Trail

Log when environment variables are used:

```bash
if [[ -n "$ALLOW_MAIN_PUSH" ]]; then
    echo "🔓 ALLOW_MAIN_PUSH enabled by: $USER at $(date)" >> /var/log/git-hooks.log
fi
```

### 3. Restrict in CI Config

```yaml
# Only allow on protected branches
deploy:
  only:
    - main
    - /^release-.*$/
  env:
    ALLOW_MAIN_PUSH: 1
```

---

## 🧪 Testing

### Test Non-Interactive Mode

```bash
# Simulate non-interactive mode
echo "" | git push origin main

# Should show:
# [BLOCKED] Cannot push to main in non-interactive mode
```

### Test with Environment Variable

```bash
# Should succeed
ALLOW_MAIN_PUSH=1 echo "" | git push origin main
```

### Test Interactive Mode

```bash
# In regular terminal, should prompt
git push origin main
# Prompts: "Are you sure you want to push to main? [y/N]"
```

---

## 🛠️ Debugging

### Check if Running in Non-Interactive Mode

```bash
if [[ ! -t 0 ]]; then
    echo "Non-interactive (stdin is not a terminal)"
else
    echo "Interactive"
fi
```

### Check CI Environment Variables

```bash
echo "CI: $CI"
echo "GITHUB_ACTIONS: $GITHUB_ACTIONS"
echo "GITLAB_CI: $GITLAB_CI"
```

### View Hook Detection

Enable debugging in hooks:

```bash
# In pre-push hook, add at top:
set -x  # Print commands as they execute
```

---

## 📚 Alternative: Using --no-verify

If you can't use environment variables:

```bash
# Bypass ALL hooks (use sparingly)
git push --no-verify origin main
git commit --no-verify -m "message"
git rebase --no-verify main
```

**Pros:**

- Quick and easy
- Works everywhere

**Cons:**

- Bypasses ALL checks (security, tests, linting)
- No audit trail
- Easy to forget and cause issues

**Environment variables are better because:**

- ✓ Only bypass specific protections
- ✓ Other checks still run (tests, linting, etc.)
- ✓ Can be audited and logged
- ✓ Self-documenting in CI config

---

## 📖 Summary

### For Interactive Development

- Let hooks prompt you (safer)
- Use `--no-verify` only in emergencies

### For CI/CD Pipelines

- Use environment variables for specific overrides
- Keep other safety checks active
- Document why in CI config

### For Automated Scripts

- Use environment variables per-command
- Don't export globally
- Add logging for audit trail

---

## ❓ FAQ

**Q: Why not just use --no-verify everywhere?**
A: Environment variables allow fine-grained control. You can bypass main branch protection while still running tests, linting, and other checks.

**Q: Can I set these permanently?**
A: You can, but it defeats the purpose of the hooks. Use them only for automation.

**Q: What if hooks still block my CI?**
A: Check the hook logs. The hook will tell you which environment variable to set.

**Q: Do these work on Windows?**
A: Yes, in Git Bash or WSL. In PowerShell, use: `$env:ALLOW_MAIN_PUSH=1; git push`

**Q: Can I add my own environment variables?**
A: Yes! Edit the hooks and add your own checks:

```bash
if [[ "$MY_CUSTOM_ALLOW" == "1" ]]; then
    # Allow operation
fi
```

---

**Need help?** Check the main hooks README or open an issue.
