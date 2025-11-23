# 🚀 Quick Installation Guide

## Phase 2 Complete! Your Hooks Are Now Portable

The hooks tested in this project have been packaged into a portable installation system located at:

```
~/.claude-code/
```

## 📦 What's Available

### Installation Script
```bash
~/.claude-code/install-hooks.sh
```

Use this to install hooks to any project!

### Hooks Library
```bash
~/.claude-code/hooks-library/
```

Template hooks that get copied to projects during installation.

### Documentation
```bash
~/.claude-code/README.md
~/.claude-code/settings-template.json
```

Complete documentation and configuration templates.

---

## 🎯 How to Use

### Install to Any Project

```bash
# Navigate to your project
cd /path/to/your/project

# Run the installer
~/.claude-code/install-hooks.sh
```

### Install Globally (All Projects)

```bash
~/.claude-code/install-hooks.sh --global
```

### Install with Options

```bash
# Force overwrite existing hooks
~/.claude-code/install-hooks.sh --force

# Install to specific directory
~/.claude-code/install-hooks.sh /path/to/project

# Show help
~/.claude-code/install-hooks.sh --help
```

---

## 📋 What Gets Installed

When you run the installer on a project, it creates:

```
your-project/
├── .claude/
│   ├── hooks/
│   │   ├── utils/
│   │   │   ├── common.sh
│   │   │   └── detect-project.sh
│   │   ├── session-start.sh
│   │   ├── pre-tool-protect.sh
│   │   ├── pre-bash-safety.sh
│   │   └── post-quality.sh
│   └── settings.json
```

All hooks are automatically configured and ready to use!

---

## ✅ Installed Hooks Features

### 1. **SessionStart** - Project Detection
- Detects TypeScript, tools, npm scripts
- Suggests missing dependencies
- Provides context to Claude

### 2. **PreToolUse** - File Protection
- Blocks editing .env, credentials, keys
- Protects sensitive files
- Customizable patterns

### 3. **PreToolUse** - Bash Safety
- Blocks dangerous commands (rm -rf /, etc.)
- Warns about suspicious operations
- Customizable danger patterns

### 4. **PostToolUse** - Quality Checks
- Auto-formats with Prettier
- Auto-lints with ESLint
- Type-checks TypeScript
- **Blocks** if errors found

---

## 🧪 Testing Your Installation

After installing to a project:

```bash
cd /your/project

# Test project detection
bash .claude/hooks/utils/detect-project.sh

# Test file protection (should block)
echo '{"tool_name": "Write", "tool_input": {"file_path": ".env"}}' | \
  bash .claude/hooks/pre-tool-protect.sh

# Test bash safety (should block)
echo '{"tool_name": "Bash", "tool_input": {"command": "rm -rf /"}}' | \
  bash .claude/hooks/pre-bash-safety.sh
```

---

## 🎨 Customization

### Modify Hooks Globally

Edit the templates in `~/.claude-code/hooks-library/` then reinstall:

```bash
vim ~/.claude-code/hooks-library/pre-tool-protect.sh
# Make your changes

# Reinstall to projects
cd /your/project
~/.claude-code/install-hooks.sh --force
```

### Modify Per-Project

Edit the installed hooks in each project:

```bash
vim /your/project/.claude/hooks/post-quality.sh
# Changes only affect this project
```

---

## 🌟 Examples

### Example 1: New React Project

```bash
npx create-react-app my-app
cd my-app
~/.claude-code/install-hooks.sh

# Hooks detect React, TypeScript, suggest ESLint/Prettier
# Auto-format happens on every file edit
```

### Example 2: Existing Next.js Project

```bash
cd ~/projects/my-nextjs-app
~/.claude-code/install-hooks.sh

# Hooks detect Next.js, existing tooling
# Quality checks use your existing config
```

### Example 3: Global Installation

```bash
~/.claude-code/install-hooks.sh --global

# Now hooks work in ALL projects automatically
# No per-project installation needed
```

---

## 📚 Additional Resources

- **Full Documentation**: `~/.claude-code/README.md`
- **Settings Template**: `~/.claude-code/settings-template.json`
- **Original Test Project**: This directory
- **Testing Results**: `TESTING_RESULTS.md` in this directory

---

## 🔧 Troubleshooting

### Hooks Not Running

```bash
# Check settings.json exists
cat .claude/settings.json

# Verify scripts are executable
ls -la .claude/hooks/*.sh

# Test manually
bash .claude/hooks/session-start.sh < /dev/null
```

### Permission Errors

```bash
chmod +x .claude/hooks/*.sh
chmod +x .claude/hooks/utils/*.sh
```

### Update Existing Installation

```bash
~/.claude-code/install-hooks.sh --force
```

---

## 💡 Pro Tips

1. **Version Control**: Commit `.claude/` to git for team consistency
2. **Customize Per-Project**: Edit installed hooks for project-specific rules
3. **Share With Team**: Everyone on the team can install the same hooks
4. **Update Regularly**: When you improve hooks, reinstall with `--force`

---

## 🎉 You're All Set!

Your hooks are now:
- ✅ Tested and working
- ✅ Packaged for easy installation
- ✅ Ready to use across all projects
- ✅ Customizable and maintainable

Install them anywhere and enjoy automated development workflows! 🚀

---

**Installation System Location:** `~/.claude-code/`
**Documentation:** `~/.claude-code/README.md`
**This Test Project:** `/Users/klz/Desktop/Prototypes/Claude Setup/`
