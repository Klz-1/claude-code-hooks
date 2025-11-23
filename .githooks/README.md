# Git Hooks Documentation

Comprehensive Git hooks for automating quality checks, preventing mistakes, and improving development workflow.

## 🚀 Quick Start

### Install Hooks

```bash
bash .githooks/install.sh
```

This will:

- Configure Git to use `.githooks` directory
- Make all hooks executable
- Show installed hooks summary

### Check Your Branch Status

```bash
bash .githooks/check-branch
```

Displays comprehensive branch information, uncommitted changes, and reminders.

---

## 📋 Available Hooks

### 1. pre-commit

**Runs before:** Every commit

**Checks:**

- ✅ Scans for secrets/credentials (API keys, passwords, tokens)
- ✅ Detects debug statements (console.log, debugger)
- ✅ Validates file sizes (blocks files > 5MB)
- ✅ Lints JavaScript/TypeScript files with ESLint
- ✅ Auto-formats code with Prettier
- ✅ Type-checks TypeScript files
- ✅ Checks for TODO/FIXME comments
- ✅ Detects merge conflict markers

**Blocks if:**

- Secrets detected in code
- Large files in commit (> 5MB)
- ESLint errors present
- TypeScript type errors
- Merge conflicts unresolved

**Auto-fixes:**

- Formatting with Prettier

---

### 2. commit-msg

**Runs before:** Commit message is finalized

**Checks:**

- ✅ Minimum message length (10 chars)
- ✅ Maximum first line length (72 chars recommended)
- ✅ Proper capitalization
- ✅ Imperative mood usage
- ✅ No trailing periods

**Adds:**

- Branch name reference
- Ticket/issue number (if in branch name)

**Optional (uncomment to enable):**

- Conventional commits enforcement (feat:, fix:, etc.)
- Required issue/ticket references

---

### 3. pre-push

**Runs before:** Pushing to remote

**Checks:**

- ⚠️ Warns when pushing to main/master
- ❌ Blocks force push to main/master
- ✅ Runs full test suite
- ✅ Verifies build succeeds
- ✅ Checks for WIP/fixup commits
- ✅ Ensures branch is up to date with remote
- ✅ Validates commit message format
- ✅ Checks for large files
- ✅ Reports code coverage (if available)

**Blocks if:**

- Force pushing to protected branches
- Tests fail
- Build fails

**Warns if:**

- Pushing to main/master (asks for confirmation)
- Branch has diverged from remote
- Uncommitted changes present
- WIP commits in history
- Large files detected
- Commit messages don't follow conventions

---

### 4. post-checkout

**Runs after:** Switching branches

**Displays:**

- 🎯 Current branch name (highlighted if protected)
- 📊 Commits ahead/behind remote
- ⚠️ Uncommitted changes count
- 📦 Stashed changes
- 📝 Last commit information
- 💡 Branch naming convention reminder

**Checks:**

- Dependency file changes (package.json, requirements.txt, etc.)
- Suggests running install commands if needed

**Warnings:**

- Red alert if on main/master
- Yellow alert if on shared branches (develop, staging)

---

### 5. post-merge

**Runs after:** Merging branches

**Auto-actions:**

- 📦 Runs `npm install` if package.json changed
- 📦 Runs `pip install` if requirements.txt changed
- 📦 Runs `bundle install` if Gemfile changed
- 🧹 Cleans dist/ and build/ if build configs changed

**Detects & Notifies:**

- Database migration changes
- .env.example updates
- Git hooks changes

---

### 6. pre-rebase

**Runs before:** Rebasing

**Safety checks:**

- ⚠️ Warns when rebasing main/master
- ⚠️ Warns when rebasing published commits
- ✅ Ensures working directory is clean
- ❌ Prevents rebase during active merge/rebase
- 📊 Shows commits that will be rebased

**Blocks if:**

- Working directory has uncommitted changes
- Another rebase/merge is in progress

---

### 7. check-branch (Utility)

**Manual command:** `bash .githooks/check-branch`

**Displays:**

- 🎯 Current branch with visual indicators
- 📡 Remote tracking status
- 📊 Working directory changes breakdown
- 📦 Stashed changes count
- 📝 Last commit details
- 💡 Quick reminders and tips
- ⏰ Commit frequency stats

**Use cases:**

- Periodic branch verification
- Quick status overview
- Ensuring you're on the right branch
- Can be added to cron for automatic checks

---

## 🎨 Customization

### Disable Specific Checks

Edit the hook file and comment out unwanted checks:

```bash
# Example: Disable debug statement warnings in pre-commit
# Comment out the debug check section
vim .githooks/pre-commit
```

### Enable Optional Features

Some features are disabled by default. Uncomment to enable:

**In commit-msg:**

```bash
# Uncomment to enforce conventional commits
CONVENTIONAL_PATTERN='^(feat|fix|docs|...)...'
```

**In pre-push:**

```bash
# Uncomment to require test coverage
# (Already has code, just needs uncommenting)
```

### Adjust Thresholds

**File size limit (pre-commit):**

```bash
MAX_SIZE=$((5 * 1024 * 1024)) # Change 5 to your limit in MB
```

**Commit message length (commit-msg):**

```bash
MIN_LENGTH=10  # Change minimum length
MAX_FIRST_LINE=72  # Change max first line length
```

### Add Protected Branches

**In pre-push:**

```bash
if [[ "$REMOTE_BRANCH" == "main" ]] || [[ "$REMOTE_BRANCH" == "master" ]] || [[ "$REMOTE_BRANCH" == "production" ]]; then
    # Your custom branch here
fi
```

---

## 🔧 Bypassing Hooks

**Not recommended, but sometimes necessary:**

```bash
# Skip pre-commit and commit-msg
git commit --no-verify

# Skip pre-push
git push --no-verify
```

**When to bypass:**

- Emergency hotfixes
- Temporary work that will be squashed
- Known false positives

**When NOT to bypass:**

- Regular development
- Production deployments
- Shared branches

---

## 🤝 Team Setup

### For Repository Owners

1. **Commit hooks to repository:**

   ```bash
   git add .githooks/
   git commit -m "Add Git hooks for quality control"
   ```

2. **Document in main README:**
   ```markdown
   ## Setup

   After cloning, install Git hooks:
   \`\`\`bash
   bash .githooks/install.sh
   \`\`\`
   ```

### For Team Members

After cloning the repository:

```bash
cd your-repo
bash .githooks/install.sh
```

**Note:** Hooks are not automatically installed when cloning. Each team member must run the install script.

---

## 📊 Hook Flow Diagrams

### Commit Flow

```
Developer writes code
         ↓
   git add files
         ↓
   git commit
         ↓
   [pre-commit runs]
   - Scans for secrets
   - Lints code
   - Formats code
   - Type checks
         ↓
   [commit-msg runs]
   - Validates message
   - Adds metadata
         ↓
   Commit created ✓
```

### Push Flow

```
Developer commits changes
         ↓
   git push
         ↓
   [pre-push runs]
   - Checks branch
   - Runs tests
   - Runs build
   - Validates commits
         ↓
   Push to remote ✓
```

### Branch Switch Flow

```
   git checkout branch
         ↓
   [post-checkout runs]
   - Shows branch info
   - Checks dependencies
   - Displays warnings
         ↓
   Working on new branch ✓
```

---

## 🐛 Troubleshooting

### Hooks not running

**Check configuration:**

```bash
git config core.hooksPath
# Should show: .githooks
```

**Reconfigure if needed:**

```bash
bash .githooks/install.sh
```

### Hooks running but failing

**Check hook permissions:**

```bash
ls -la .githooks/
# All hooks should be executable (-rwxr-xr-x)
```

**Make executable:**

```bash
chmod +x .githooks/*
```

### False positives

**Temporarily bypass:**

```bash
git commit --no-verify
```

**Or adjust hook settings:**

```bash
vim .githooks/pre-commit
# Adjust patterns or thresholds
```

### Performance issues

**For large repositories:**

1. **Disable TypeScript full project check:**

   ```bash
   # In pre-commit, change:
   npx tsc --noEmit
   # To:
   npx tsc --noEmit --incremental
   ```

2. **Limit files checked:**

   ```bash
   # Only check staged files, not all files
   ```

3. **Move expensive checks to pre-push:**
   ```bash
   # Move test suite from pre-commit to pre-push
   ```

---

## 📚 Additional Tools

### Periodic Branch Checker (Cron)

Add to crontab for automatic checks every 30 minutes:

```bash
crontab -e

# Add this line:
*/30 * * * * cd /path/to/repo && bash .githooks/check-branch > /tmp/branch-check.log 2>&1
```

### Terminal Prompt Integration

Add to your `.bashrc` or `.zshrc`:

```bash
# Show git branch in prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
```

---

## 🎯 Best Practices

1. **Install hooks immediately** after cloning
2. **Don't bypass hooks** unless absolutely necessary
3. **Keep hooks updated** - pull latest from team
4. **Run check-branch** periodically throughout the day
5. **Commit often** - hooks catch issues early
6. **Review hook output** - don't ignore warnings
7. **Customize for your workflow** - adjust thresholds as needed
8. **Document bypasses** - if you must bypass, explain why in commit message

---

## 🔗 Integration with CI/CD

These hooks complement CI/CD but don't replace it:

**Local hooks:**

- Fast feedback (seconds)
- Catch obvious issues
- Developer-friendly

**CI/CD:**

- Comprehensive testing
- Multiple environments
- Deployment automation

**Use both for best results!**

---

## 📝 License

Same as main project

---

## 🤝 Contributing

To add new hooks:

1. Create hook file in `.githooks/`
2. Make executable: `chmod +x .githooks/your-hook`
3. Update this README
4. Test thoroughly
5. Submit PR

---

**Questions?** Check main README or open an issue.
