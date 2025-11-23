# 🔄 Updating Existing Hook Installations

## Quick Answer

```bash
# For Claude Code hooks
cd /path/to/your/project
~/.claude-code/install-hooks.sh --force

# For Git hooks
cd /path/to/your/project
cp -r "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks" .
bash .githooks/install.sh
```

---

## 📦 Scenario 1: Update Claude Code Hooks

### If You Installed Per-Project

```bash
# Navigate to your project
cd /path/to/your/project

# Reinstall with --force (overwrites old hooks)
~/.claude-code/install-hooks.sh --force
```

**What happens:**

- ✓ Old hooks in `.claude/hooks/` are replaced
- ✓ Settings.json is preserved (hooks section updated)
- ✓ New features (non-interactive mode) now available

**Verify:**

```bash
# Check files were updated
ls -la .claude/hooks/

# Look for recent modification dates
```

---

### If You Installed Globally

```bash
# Update global hooks
~/.claude-code/install-hooks.sh --global --force
```

**What happens:**

- ✓ Hooks in `~/.claude/hooks/` are updated
- ✓ All your projects get new hooks automatically
- ✓ No need to update individual projects

**Verify:**

```bash
ls -la ~/.claude/hooks/
cat ~/.claude/settings.json
```

---

### Update Multiple Projects

```bash
# Update all your projects at once
for project in ~/projects/*/; do
    echo "Updating $project..."
    cd "$project"
    if [ -d ".claude/hooks" ]; then
        ~/.claude-code/install-hooks.sh --force
    fi
done
```

---

## 🔧 Scenario 2: Update Git Hooks

### Method 1: Pull from Repository (If Committed)

If Git hooks are committed to your project repository:

```bash
cd /path/to/your/project

# Pull latest version
git pull origin main

# Reinstall (updates git config)
bash .githooks/install.sh
```

---

### Method 2: Copy from Test Project

If you haven't committed hooks yet, or want to manually update:

```bash
cd /path/to/your/project

# Backup existing hooks (optional)
cp -r .githooks .githooks.backup.$(date +%Y%m%d)

# Copy new hooks from test project
cp -r "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks" .

# Reinstall
bash .githooks/install.sh
```

**Verify:**

```bash
# Check git config
git config core.hooksPath
# Should show: .githooks

# Check files updated
ls -la .githooks/

# Check for CI_CD_GUIDE.md (new file in latest version)
ls -la .githooks/CI_CD_GUIDE.md
```

---

### Method 3: Git Pull from Template Repo

If you cloned this project as a template:

```bash
cd /path/to/your/project

# Add template repo as remote (if not already added)
git remote add hooks-template https://github.com/Klz-1/claude-code-hooks.git

# Fetch latest
git fetch hooks-template

# Merge just the .githooks directory
git checkout hooks-template/main -- .githooks

# Reinstall
bash .githooks/install.sh

# Commit the update
git add .githooks/
git commit -m "Update Git hooks to latest version"
```

---

## 🔄 Scenario 3: Update Both Systems

Complete update for a project with both hook systems:

```bash
cd /path/to/your/project

# Update Claude Code hooks
echo "📦 Updating Claude Code hooks..."
~/.claude-code/install-hooks.sh --force

# Update Git hooks
echo "🔧 Updating Git hooks..."
cp -r "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks" .
bash .githooks/install.sh

echo "✅ Both hook systems updated!"
```

---

## 📋 What's New in Latest Version?

### Claude Code Hooks

- _(No changes in this update)_

### Git Hooks (v2.0)

- ✅ **Non-interactive mode detection**
  - Auto-detects CI/CD environments
  - No more blocking in automated workflows

- ✅ **Environment variable overrides**
  - `ALLOW_MAIN_PUSH=1` - Push to protected branches
  - `ALLOW_FORCE_PUSH=1` - Force push in automation
  - `ALLOW_REBASE_MAIN=1` - Rebase onto main
  - `ALLOW_REBASE_PUBLIC=1` - Rebase published commits

- ✅ **New documentation**
  - `.githooks/CI_CD_GUIDE.md` - Complete CI/CD guide
  - Examples for GitHub Actions, GitLab CI
  - Security best practices

- ✅ **Better error messages**
  - Clear instructions when blocked
  - Tells you which environment variable to use

---

## 🔍 Verify Update Was Successful

### Check Claude Code Hooks Version

```bash
# Look at a hook file
head -20 .claude/hooks/pre-tool-protect.sh

# Should contain the logic you expect
```

### Check Git Hooks Version

```bash
# Check for new CI_CD_GUIDE.md
ls -la .githooks/CI_CD_GUIDE.md

# Check pre-push has non-interactive detection
grep -A 5 "non-interactive mode" .githooks/pre-push

# Should see:
# if [[ ! -t 0 ]] || [[ -n "$CI" ]] ...
```

### Test Non-Interactive Mode

```bash
# Should show clear message
echo "" | git push origin main 2>&1 | grep "ALLOW_MAIN_PUSH"

# Should see:
# [BLOCKED] Cannot push to main in non-interactive mode
#            Set ALLOW_MAIN_PUSH=1 to override or use --no-verify
```

### Test Environment Variable

```bash
# Should work without prompting
ALLOW_MAIN_PUSH=1 echo "" | git push origin main

# Or test in current terminal:
cd /path/to/your/project
ALLOW_MAIN_PUSH=1 git push origin main
```

---

## ⚠️ Troubleshooting Update Issues

### Issue: Hooks not updating

**Cause:** Install script didn't run or permissions issue

**Fix:**

```bash
# Make sure you're using --force
~/.claude-code/install-hooks.sh --force

# Check permissions
ls -la ~/.claude-code/hooks-library/

# All should be executable (-rwxr-xr-x)
chmod +x ~/.claude-code/hooks-library/*.sh
chmod +x ~/.claude-code/hooks-library/utils/*.sh

# Try again
~/.claude-code/install-hooks.sh --force
```

---

### Issue: Git hooks still prompting

**Cause:** Old hooks still in place or git config not updated

**Fix:**

```bash
# Completely remove old hooks
rm -rf .githooks/

# Copy fresh from template
cp -r "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks" .

# Make executable
chmod +x .githooks/*.sh

# Reinstall
bash .githooks/install.sh

# Verify config
git config core.hooksPath
# Should show: .githooks
```

---

### Issue: Old hook behavior persists

**Cause:** Git is using old hooks from `.git/hooks/` instead of `.githooks/`

**Fix:**

```bash
# Check what git is using
git config core.hooksPath

# If empty or wrong, reinstall
bash .githooks/install.sh

# Verify
git config core.hooksPath
# Should be: .githooks
```

---

### Issue: Can't find template project

**Cause:** You don't have the test project anymore

**Fix:**

```bash
# Clone fresh from GitHub
cd ~/Downloads
git clone https://github.com/Klz-1/claude-code-hooks.git

# Copy hooks from there
cd /path/to/your/project
cp -r ~/Downloads/claude-code-hooks/.githooks .
bash .githooks/install.sh
```

---

## 🚀 Update Multiple Projects Script

Save this as `update-all-hooks.sh`:

```bash
#!/bin/bash
# Update hooks in all projects

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Projects directory
PROJECTS_DIR="${1:-$HOME/projects}"

echo -e "${BLUE}Updating hooks in all projects under: $PROJECTS_DIR${NC}"
echo ""

UPDATED=0
SKIPPED=0

for project in "$PROJECTS_DIR"/*/; do
    project_name=$(basename "$project")

    cd "$project" || continue

    # Check if this is a git repo
    if [ ! -d ".git" ]; then
        echo -e "${YELLOW}[SKIP]${NC} $project_name (not a git repo)"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    echo -e "${BLUE}[UPDATE]${NC} $project_name"

    # Update Claude Code hooks if present
    if [ -d ".claude/hooks" ]; then
        ~/.claude-code/install-hooks.sh --force > /dev/null 2>&1
        echo "  ✓ Claude Code hooks updated"
    fi

    # Update Git hooks if present
    if [ -d ".githooks" ]; then
        cp -r "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks" .
        bash .githooks/install.sh > /dev/null 2>&1
        echo "  ✓ Git hooks updated"
    fi

    UPDATED=$((UPDATED + 1))
    echo ""
done

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Update complete!${NC}"
echo -e "  Updated: $UPDATED projects"
echo -e "  Skipped: $SKIPPED projects"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
```

**Usage:**

```bash
# Update all projects in ~/projects
bash update-all-hooks.sh

# Update all projects in custom directory
bash update-all-hooks.sh /path/to/projects
```

---

## 📝 Update Checklist

Use this checklist when updating:

### Claude Code Hooks

- [ ] Navigate to project: `cd /path/to/project`
- [ ] Run installer with --force: `~/.claude-code/install-hooks.sh --force`
- [ ] Verify files updated: `ls -la .claude/hooks/`
- [ ] Test with Claude Code session

### Git Hooks

- [ ] Backup existing (optional): `cp -r .githooks .githooks.backup`
- [ ] Copy new hooks: `cp -r ".../Claude Setup/.githooks" .`
- [ ] Reinstall: `bash .githooks/install.sh`
- [ ] Verify config: `git config core.hooksPath`
- [ ] Check for CI_CD_GUIDE.md: `ls .githooks/CI_CD_GUIDE.md`
- [ ] Test non-interactive mode: `echo "" | git push`
- [ ] Test environment variable: `ALLOW_MAIN_PUSH=1 git push`

### Both Systems

- [ ] All hooks executable: `ls -la .githooks/ .claude/hooks/`
- [ ] No error messages when running commands
- [ ] New features work as expected

---

## 🎯 Best Practices for Future Updates

### 1. Version Control Git Hooks

Commit Git hooks to your repository:

```bash
git add .githooks/
git commit -m "Update Git hooks to v2.0"
git push
```

**Benefits:**

- Team gets updates automatically with `git pull`
- Easy to track changes
- Can revert if needed

### 2. Document Which Version

Add to your project README:

```markdown
## Git Hooks

This project uses Git hooks for quality control.

**Version:** 2.0 (with non-interactive mode support)
**Last updated:** 2025-11-23

**Setup:**
\`\`\`bash
bash .githooks/install.sh
\`\`\`
```

### 3. Keep Template Repo Handy

Bookmark or star the GitHub repo:

- https://github.com/Klz-1/claude-code-hooks

Or clone to a permanent location:

```bash
git clone https://github.com/Klz-1/claude-code-hooks.git ~/.claude-code/template
```

Then update from there:

```bash
cd /path/to/project
cp -r ~/.claude-code/template/.githooks .
bash .githooks/install.sh
```

### 4. Automated Updates (Advanced)

Add to your CI/CD to check for updates:

```yaml
# .github/workflows/update-hooks.yml
name: Check Hook Updates

on:
  schedule:
    - cron: '0 0 * * 1' # Weekly

jobs:
  check-updates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Check for hook updates
        run: |
          git clone https://github.com/Klz-1/claude-code-hooks.git /tmp/hooks
          if ! diff -r .githooks /tmp/hooks/.githooks > /dev/null; then
            echo "Hook updates available!"
            # Create PR or notify team
          fi
```

---

## ❓ FAQ

**Q: Will updating break my custom modifications?**
A: Yes, `--force` overwrites everything. Backup first or merge changes manually.

**Q: Do I need to update all projects at once?**
A: No, update as needed. But v2.0 fixes critical automation issues, so update soon.

**Q: Can I keep old hooks in some projects?**
A: Yes, hooks are per-project. Update individually as needed.

**Q: What if my team hasn't updated yet?**
A: Old and new hooks are compatible. No coordination needed.

**Q: Will this affect committed code?**
A: No, hooks only change how git operations work, not your code.

**Q: How do I know what version I have?**
A: Check for `.githooks/CI_CD_GUIDE.md`. If it exists, you have v2.0+.

---

## 🆘 Need Help?

If you run into issues:

1. **Check the logs:**

   ```bash
   bash .githooks/install.sh 2>&1 | tee install.log
   ```

2. **Verify source:**

   ```bash
   ls -la "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks/"
   ```

3. **Clean install:**

   ```bash
   rm -rf .githooks .claude/hooks
   # Then reinstall from scratch
   ```

4. **Open an issue:**
   - https://github.com/Klz-1/claude-code-hooks/issues

---

**Happy updating!** 🚀
