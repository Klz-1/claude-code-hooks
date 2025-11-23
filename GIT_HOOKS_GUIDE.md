# Git Hooks Integration Guide

## 🎯 Overview

This project includes comprehensive Git hooks for:

- ✅ **Quality Control** - Auto-format, lint, type-check before commits
- 🛡️ **Security** - Block secrets, credentials, dangerous operations
- 🚀 **Automation** - Auto-install dependencies, clean builds
- 📊 **Awareness** - Branch status, reminders, safety warnings

---

## 🚀 Quick Setup

### Automatic Installation (Recommended)

```bash
npm install
```

The `prepare` script automatically installs Git hooks when you run `npm install`.

### Manual Installation

```bash
bash .githooks/install.sh
```

---

## 📋 Available Git Hooks

### 1. pre-commit - Quality Gate

**Runs before every commit**

Automatically:

- ✅ Scans for secrets (API keys, passwords, tokens)
- ✅ Detects debug statements (`console.log`, `debugger`)
- ✅ Blocks large files (> 5MB)
- ✅ Lints with ESLint (auto-fixes issues)
- ✅ Formats with Prettier (auto-formats code)
- ✅ Type-checks TypeScript
- ✅ Detects merge conflicts

**Example output:**

```
[PRE-COMMIT] Running pre-commit checks...
[CHECK] Scanning for secrets...
[CHECK] Checking for debug statements...
[CHECK] Checking for large files...
[CHECK] Running ESLint on staged files...
[AUTO-FIX] Formatting: src/index.ts
[CHECK] Running TypeScript type-check...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[SUCCESS] All pre-commit checks passed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### 2. commit-msg - Message Validation

**Runs before commit message is saved**

Validates:

- ✅ Minimum length (10 chars)
- ✅ Proper format
- ✅ Adds branch reference automatically

**Example:**

```
Before: "fix bug"
After:  "fix bug

[Branch: feature/user-auth]"
```

---

### 3. pre-push - Comprehensive Validation

**Runs before pushing to remote**

Checks:

- ⚠️ Warns when pushing to main/master
- ❌ Blocks force push to protected branches
- ✅ Runs full test suite
- ✅ Verifies build succeeds
- ✅ Checks for WIP commits
- ✅ Validates branch is up to date

**Example:**

```
[PRE-PUSH] Running pre-push checks...
[CHECK] Verifying target branch...
[WARNING] Pushing directly to main
Are you sure you want to push to main? [y/N]
```

---

### 4. post-checkout - Branch Awareness

**Runs after switching branches**

Displays:

- 🎯 Current branch (highlighted if protected)
- 📊 Commits ahead/behind remote
- ⚠️ Uncommitted changes
- 📦 Dependency changes
- 💡 Quick tips

**Example:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Branch Checkout Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚠️  On protected branch: main
      Be careful making changes directly on this branch

  🌐 Remote Tracking
  ├─ Tracking: origin/main
  └─ Status: ✓ Up to date

  📊 Working Directory
  └─ ✓ Clean (no changes)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### 5. post-merge - Auto-Maintenance

**Runs after merging branches**

Automatically:

- 📦 Runs `npm install` if package.json changed
- 🧹 Cleans dist/ if build config changed
- 📢 Notifies about migration files
- ⚠️ Warns about .env changes

**Example:**

```
[POST-MERGE] Running post-merge automation...
[DETECTED] package.json changed
[ACTION] Running npm install...
[SUCCESS] Dependencies updated
```

---

### 6. pre-rebase - Safety Checks

**Runs before rebasing**

Prevents:

- ⚠️ Rebasing protected branches without confirmation
- ❌ Rebasing with uncommitted changes
- ⚠️ Rebasing published commits (warns)

---

### 7. check-branch - Status Utility

**Manual command for branch verification**

```bash
bash .githooks/check-branch
```

**Displays:**

```
╔════════════════════════════════════════════════════════╗
║           GIT BRANCH STATUS CHECK                      ║
╚════════════════════════════════════════════════════════╝

  📁 Repository: claude-code-hooks
  📍 Location: /Users/you/projects/claude-code-hooks

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ FEATURE BRANCH
  ➜  feature/add-git-hooks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  🌐 Remote Tracking
  ├─ Tracking: origin/feature/add-git-hooks
  ├─ Status: Ahead
  └─ ↑ 3 unpushed commit(s)

  💡 Ready to push: git push

  📊 Working Directory
  ├─ 2 file(s) with changes
  ├─ Modified: 2

  💡 View details: git status

  📝 Last Commit
  ├─ abc1234 - Add Git hooks system
  ├─ Author: Your Name
  └─ 2 hours ago
```

---

## 🎨 Customization

### Disable Specific Checks

Edit the hook file:

```bash
vim .githooks/pre-commit

# Comment out unwanted sections
# For example, to disable debug statement warnings:
# Comment out lines 40-52
```

### Adjust Thresholds

**File size limit:**

```bash
# In .githooks/pre-commit, line 79
MAX_SIZE=$((5 * 1024 * 1024))  # Change 5 to your limit
```

**Commit message length:**

```bash
# In .githooks/commit-msg, line 24
MIN_LENGTH=10  # Change minimum length
```

### Enable Optional Features

**Enforce conventional commits:**

```bash
# In .githooks/commit-msg, uncomment lines 38-46
CONVENTIONAL_PATTERN='^(feat|fix|docs|...)...'
```

---

## 🔧 Bypassing Hooks

**When necessary (not recommended):**

```bash
# Skip pre-commit and commit-msg
git commit --no-verify -m "Emergency fix"

# Skip pre-push
git push --no-verify
```

**Use only for:**

- Emergency hotfixes
- Known false positives
- Temporary WIP commits

---

## 🤝 Team Setup

### For New Team Members

After cloning:

```bash
git clone https://github.com/your-org/project.git
cd project
npm install  # Hooks install automatically
```

### Verifying Installation

```bash
# Check hooks are configured
git config core.hooksPath
# Should show: .githooks

# List installed hooks
ls -la .githooks/
```

---

## 🐛 Troubleshooting

### Hooks Not Running

**Check configuration:**

```bash
git config core.hooksPath
```

**Should return:** `.githooks`

**If not, reinstall:**

```bash
bash .githooks/install.sh
```

### Hooks Running But Failing

**Check permissions:**

```bash
ls -la .githooks/
# All hooks should show: -rwxr-xr-x
```

**Fix permissions:**

```bash
chmod +x .githooks/*
```

### Performance Issues

**For large repos, move expensive checks to pre-push:**

```bash
# Edit .githooks/pre-commit
# Comment out test suite section
# Tests will still run in pre-push
```

---

## 📊 Workflow Examples

### Typical Commit Flow

```bash
# 1. Write code
vim src/index.ts

# 2. Stage changes
git add src/index.ts

# 3. Commit (hooks run automatically)
git commit -m "Add new feature"

# Output:
[PRE-COMMIT] Running pre-commit checks...
[CHECK] Scanning for secrets...
[CHECK] Running ESLint on staged files...
[AUTO-FIX] Formatting: src/index.ts
[SUCCESS] All pre-commit checks passed!

[COMMIT-MSG] Validating commit message...
[INFO] Added branch reference to commit message
[SUCCESS] Commit message validated
```

### Pushing to Remote

```bash
git push

# Output:
[PRE-PUSH] Running pre-push checks...
[CHECK] Verifying target branch...
[CHECK] Running test suite...
[PASSED] All tests passed
[CHECK] Running build...
[PASSED] Build successful
[SUCCESS] All pre-push checks passed!
```

### Switching Branches

```bash
git checkout feature/new-feature

# Output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Branch Checkout Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Current branch: feature/new-feature
  🌐 Remote Tracking
  └─ ✓ Up to date with remote
```

---

## 💡 Best Practices

1. **Never bypass hooks** in production branches
2. **Run check-branch** periodically throughout the day
3. **Commit often** - hooks catch issues early
4. **Review warnings** - don't ignore them
5. **Keep hooks updated** - pull latest from team
6. **Document bypasses** - explain why in commit message

---

## 🔗 Integration with CI/CD

Git hooks complement CI/CD:

| Aspect | Git Hooks      | CI/CD            |
| ------ | -------------- | ---------------- |
| Speed  | Instant (< 1s) | Minutes          |
| Scope  | Local changes  | Full codebase    |
| Cost   | Free           | Server resources |
| Bypass | Possible       | Enforced         |

**Use both for best results!**

---

## 📚 Additional Resources

- **Full Documentation**: `.githooks/README.md`
- **Hook Scripts**: `.githooks/` directory
- **Customization**: Edit individual hook files
- **Issues**: Open GitHub issue if problems occur

---

**Questions?** Check `.githooks/README.md` or ask the team!
