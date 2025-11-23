# 🚀 Complete Installation Instructions

## Two Hook Systems

This project provides **two complementary hook systems**:

1. **Claude Code Hooks** - Automate Claude's development workflow
2. **Git Hooks** - Enforce quality control during git operations

---

## 📦 Claude Code Hooks Installation

### Option 1: Install to a Specific Project

```bash
# Navigate to your project
cd /path/to/your/project

# Run the installer
~/.claude-code/install-hooks.sh
```

**What this does:**

- Creates `.claude/hooks/` in your project
- Creates `.claude/settings.json`
- Makes all scripts executable
- Ready to use immediately with Claude Code

**Example:**

```bash
cd ~/projects/my-react-app
~/.claude-code/install-hooks.sh

# Output:
✓ Claude Code Hooks Installed Successfully!
  Location: ~/projects/my-react-app/.claude
```

---

### Option 2: Install Globally (All Projects)

```bash
~/.claude-code/install-hooks.sh --global
```

**What this does:**

- Installs to `~/.claude/hooks/`
- Updates `~/.claude/settings.json`
- Works for **all** your projects automatically

**When to use:**

- You want the same hooks across all projects
- You're the only developer
- You want consistent automation everywhere

---

### Option 3: Force Overwrite Existing

```bash
cd /path/to/project
~/.claude-code/install-hooks.sh --force
```

**Use when:**

- Updating hooks to latest version
- Overwriting custom modifications
- Reinstalling after issues

---

## 🔧 Git Hooks Installation

Git hooks are **project-specific** and need to be in each repository.

### For a New Project

**Option A: Copy from this test project**

```bash
# Navigate to your new project
cd /path/to/your/new-project

# Initialize git if needed
git init

# Copy the git hooks
cp -r "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks" .

# Install hooks
bash .githooks/install.sh
```

**Option B: Clone this repository**

```bash
# Clone as a template
git clone https://github.com/Klz-1/claude-code-hooks.git my-new-project
cd my-new-project

# Remove git history (start fresh)
rm -rf .git
git init

# Hooks are already there
bash .githooks/install.sh
```

---

### For an Existing Project

**Step 1: Copy hooks directory**

```bash
# From this test project
cd /path/to/your/existing-project

# Copy the .githooks directory
cp -r "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks" .
```

**Step 2: Add to package.json (for auto-installation)**

Add this to your `package.json` scripts:

```json
{
  "scripts": {
    "prepare": "bash .githooks/install.sh 2>/dev/null || true"
  }
}
```

**Step 3: Install hooks**

```bash
bash .githooks/install.sh
```

**Step 4: Commit to repository**

```bash
git add .githooks/
git add package.json  # if you modified it
git commit -m "Add Git hooks for quality control"
git push
```

Now all team members will get hooks automatically when they run `npm install`!

---

## 👥 Team Member Setup

### New Team Member Joining

**When someone clones your repository:**

```bash
# Clone the repository
git clone https://github.com/your-org/your-project.git
cd your-project

# Install dependencies (Git hooks install automatically via prepare script)
npm install

# Install Claude Code hooks (optional, per developer preference)
~/.claude-code/install-hooks.sh
```

**That's it!** Both hook systems are now active.

---

## 🎯 Complete Setup Example

### Scenario: Setting up a new React project with all hooks

```bash
# 1. Create new React app
npx create-react-app my-app
cd my-app

# 2. Install Claude Code hooks
~/.claude-code/install-hooks.sh

# 3. Copy Git hooks
cp -r "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks" .

# 4. Add prepare script to package.json
# (manually edit or use this one-liner)
cat package.json | jq '.scripts.prepare = "bash .githooks/install.sh 2>/dev/null || true"' > package.json.tmp && mv package.json.tmp package.json

# 5. Install Git hooks
bash .githooks/install.sh

# 6. Initialize git and commit
git init
git add .
git commit -m "Initial commit with hooks"

# 7. Create GitHub repo and push
gh repo create my-app --public --source=. --push
```

**Done!** Your project now has:

- ✅ Claude Code automation hooks
- ✅ Git quality control hooks
- ✅ Auto-installation for team members

---

## 📋 Verification Checklist

### After Installing Claude Code Hooks

```bash
# Check installation
ls -la .claude/hooks/

# Should show:
# session-start.sh
# pre-tool-protect.sh
# pre-bash-safety.sh
# post-quality.sh
# utils/

# Check settings
cat .claude/settings.json

# Should have "hooks" section
```

### After Installing Git Hooks

```bash
# Check git configuration
git config core.hooksPath
# Should return: .githooks

# List installed hooks
ls -la .githooks/
# Should show all hooks with execute permissions (-rwxr-xr-x)

# Test branch checker
bash .githooks/check-branch
# Should show beautiful branch status
```

---

## 🔄 Updating Hooks

### Update Claude Code Hooks

```bash
# Edit the master templates
vim ~/.claude-code/hooks-library/pre-tool-protect.sh

# Reinstall to projects with --force
cd /path/to/project
~/.claude-code/install-hooks.sh --force
```

### Update Git Hooks

**Option 1: Pull from this repository**

```bash
# If you committed this repo to your project
git pull origin main

# Reinstall
bash .githooks/install.sh
```

**Option 2: Manual update**

```bash
# Copy updated hooks
cp -r "/Users/klz/Desktop/Prototypes/Claude Setup/.githooks" .

# Reinstall
bash .githooks/install.sh

# Commit updates
git add .githooks/
git commit -m "Update Git hooks"
git push
```

---

## 🛠️ Troubleshooting

### Claude Code Hooks Not Running

```bash
# Verify installation
ls -la .claude/hooks/

# Check settings
cat .claude/settings.json

# Reinstall
~/.claude-code/install-hooks.sh --force
```

### Git Hooks Not Running

```bash
# Check git config
git config core.hooksPath
# If not ".githooks", run:
bash .githooks/install.sh

# Check permissions
ls -la .githooks/
# All should be executable (-rwxr-xr-x)

# Fix if needed
chmod +x .githooks/*
```

### Hooks Running on Wrong Project

```bash
# Claude Code hooks are per-project (unless installed globally)
# Check which settings file is being used
echo "Project: $(pwd)/.claude/settings.json"
echo "Global: ~/.claude/settings.json"

# Git hooks are per-project (always)
git config core.hooksPath  # Should be .githooks
```

---

## 📚 Quick Reference

### Claude Code Hooks Commands

```bash
# Install to current project
~/.claude-code/install-hooks.sh

# Install to specific project
~/.claude-code/install-hooks.sh /path/to/project

# Install globally
~/.claude-code/install-hooks.sh --global

# Force overwrite
~/.claude-code/install-hooks.sh --force

# Show help
~/.claude-code/install-hooks.sh --help
```

### Git Hooks Commands

```bash
# Install hooks
bash .githooks/install.sh

# Check branch status
bash .githooks/check-branch

# Bypass pre-commit (not recommended)
git commit --no-verify

# Bypass pre-push (not recommended)
git push --no-verify
```

---

## 🎨 Customization

### Per-Project Customization

After installation, edit hooks in the project:

```bash
# Claude Code hooks
vim .claude/hooks/pre-tool-protect.sh

# Git hooks
vim .githooks/pre-commit
```

Changes only affect this project.

### Global Customization

Edit the master templates:

```bash
# Claude Code hooks
vim ~/.claude-code/hooks-library/pre-tool-protect.sh

# Then reinstall to projects:
cd /path/to/project
~/.claude-code/install-hooks.sh --force
```

---

## 💡 Best Practices

### For Individual Developers

1. Install Claude Code hooks **globally** for consistent behavior
2. Install Git hooks **per-project** from your team's repository
3. Customize as needed for your workflow

### For Teams

1. **Commit Git hooks to repository** (in `.githooks/`)
2. **Add prepare script** to package.json for auto-installation
3. **Document in README** that team should run `npm install`
4. **Claude Code hooks** are optional per developer

### For Open Source Projects

1. **Include Git hooks** in repository
2. **Make them optional** (don't force auto-install)
3. **Document how to enable** in CONTRIBUTING.md
4. **Provide bypass instructions** for edge cases

---

## 📖 Additional Resources

- **Full Documentation**
  - Claude Code Hooks: `~/.claude-code/README.md`
  - Git Hooks: `.githooks/README.md`

- **Quick Guides**
  - `README.md` - Testing guide
  - `INSTALLATION_GUIDE.md` - Installation overview
  - `GIT_HOOKS_GUIDE.md` - Git hooks integration
  - `QUICK_REFERENCE.md` - One-page cheat sheet

- **GitHub Repository**
  - https://github.com/Klz-1/claude-code-hooks

---

## ❓ FAQ

**Q: Can I use Claude Code hooks without Git hooks?**
A: Yes! They're independent. Install just what you need.

**Q: Can I use Git hooks without Claude Code hooks?**
A: Yes! Git hooks work standalone.

**Q: Do hooks work on Windows?**
A: Git hooks require bash. Use Git Bash or WSL on Windows.

**Q: Can I disable specific hooks?**
A: Yes! Delete the hook file or comment out checks inside it.

**Q: Will hooks slow down my workflow?**
A: Minimal impact (< 1 second). Pre-push is slower but prevents errors.

**Q: Can I bypass hooks in emergencies?**
A: Yes! Use `git commit --no-verify` or `git push --no-verify`

**Q: How do I uninstall hooks?**
A:

- Claude Code: Delete `.claude/hooks/` directory
- Git: Run `git config --unset core.hooksPath`

---

**Need help?** Open an issue on GitHub or check the detailed documentation in each hook directory.
