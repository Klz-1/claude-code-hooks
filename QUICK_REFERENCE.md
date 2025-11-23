# 📋 Claude Code Hooks - Quick Reference Card

## 🎯 One-Line Installations

```bash
# Install to current project
~/.claude-code/install-hooks.sh

# Install to specific project
~/.claude-code/install-hooks.sh /path/to/project

# Install globally (all projects)
~/.claude-code/install-hooks.sh --global

# Force overwrite
~/.claude-code/install-hooks.sh --force
```

---

## 📂 Important Locations

```bash
# Installation System
~/.claude-code/
├── install-hooks.sh          # Main installer
├── hooks-library/            # Template hooks
├── settings-template.json    # Configuration
└── README.md                 # Full documentation

# After Installation (per project)
your-project/.claude/
├── hooks/                    # Working hooks
└── settings.json             # Configuration
```

---

## 🎨 What Each Hook Does

| Hook | When It Runs | What It Does |
|------|-------------|--------------|
| **session-start** | Session starts | Detects tools, suggests installs |
| **pre-tool-protect** | Before Write/Edit | Blocks .env, credentials, keys |
| **pre-bash-safety** | Before Bash commands | Blocks rm -rf /, dangerous commands |
| **post-quality** | After Write/Edit | Auto-formats, lints, type-checks |

---

## 🧪 Quick Tests

```bash
# Test project detection
bash .claude/hooks/utils/detect-project.sh

# Test file protection (should block)
echo '{"tool_name": "Write", "tool_input": {"file_path": ".env"}}' | \
  bash .claude/hooks/pre-tool-protect.sh

# Test bash safety (should block)
echo '{"tool_name": "Bash", "tool_input": {"command": "rm -rf /"}}' | \
  bash .claude/hooks/pre-bash-safety.sh

# Test quality checks (needs package.json)
echo '{"tool_name": "Write", "tool_input": {"file_path": "test.ts"}}' | \
  bash .claude/hooks/post-quality.sh
```

---

## 🔧 Common Customizations

### Add Protected File Pattern

```bash
# Edit template
vim ~/.claude-code/hooks-library/pre-tool-protect.sh

# Find PROTECTED_PATTERNS and add:
PROTECTED_PATTERNS=(
    '\.env$'
    'your-pattern-here\.json$'  # <-- Add this
)

# Reinstall
cd /your/project && ~/.claude-code/install-hooks.sh --force
```

### Add Dangerous Command Pattern

```bash
# Edit template
vim ~/.claude-code/hooks-library/pre-bash-safety.sh

# Find DANGEROUS_PATTERNS and add:
DANGEROUS_PATTERNS=(
    'rm\s+-rf\s+/'
    'your-dangerous-cmd'  # <-- Add this
)

# Reinstall
cd /your/project && ~/.claude-code/install-hooks.sh --force
```

### Change Quality Check Timeout

```bash
# Edit settings.json in your project
vim .claude/settings.json

# Find PostToolUse and change:
{
  "timeout": 30  // <-- Change this
}
```

---

## 🛠️ Troubleshooting

| Problem | Solution |
|---------|----------|
| Hooks not running | Check `cat .claude/settings.json` |
| Permission denied | Run `chmod +x .claude/hooks/*.sh` |
| JSON syntax error | Validate with `python3 -m json.tool .claude/settings.json` |
| Hooks too slow | Reduce timeout values in settings.json |
| Missing tools | Run `npm install` for dev dependencies |

---

## 📚 Documentation Quick Links

```bash
# Full installation docs
cat ~/.claude-code/README.md

# Test project guide
cat "/Users/klz/Desktop/Prototypes/Claude Setup/README.md"

# Testing results
cat "/Users/klz/Desktop/Prototypes/Claude Setup/TESTING_RESULTS.md"

# Installation guide
cat "/Users/klz/Desktop/Prototypes/Claude Setup/INSTALLATION_GUIDE.md"

# Complete summary
cat "/Users/klz/Desktop/Prototypes/Claude Setup/PROJECT_SUMMARY.md"
```

---

## 🎯 Common Workflows

### New Project Setup

```bash
# Create project
npx create-react-app my-app
cd my-app

# Install hooks
~/.claude-code/install-hooks.sh

# Install dev tools (for quality checks)
npm install --save-dev prettier eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin

# Start coding with Claude Code
# Hooks run automatically!
```

### Add to Existing Project

```bash
cd ~/projects/existing-project

# Install hooks
~/.claude-code/install-hooks.sh

# If package.json exists, hooks detect tools automatically
# Start using Claude Code - hooks active!
```

### Global Installation

```bash
# Install once
~/.claude-code/install-hooks.sh --global

# Use in any project
cd ~/projects/any-project
# Hooks already active!
```

### Team Setup

```bash
# Project lead installs
cd ~/team-project
~/.claude-code/install-hooks.sh

# Commit to git
git add .claude/
git commit -m "Add Claude Code hooks"
git push

# Team members clone
git clone ...
# Hooks ready to use immediately
```

---

## 💡 Pro Tips

- 📌 **Version Control**: Commit `.claude/` to share with team
- 🔄 **Update Often**: Run `--force` to update after template changes
- 🎨 **Customize Per-Project**: Edit installed hooks for project-specific rules
- 🌐 **Global First**: Try `--global` then customize per-project as needed
- 📊 **Check Logs**: Use Claude Code verbose mode to see hook output

---

## 🚨 Protected Files (Default)

```
.env, .env.local, .env.production, .env.development
credentials.json, secrets.json
*.key, *.pem, *.p12
private_key, aws_credentials
.npmrc, .pypirc
```

---

## 🚫 Blocked Commands (Default)

```bash
rm -rf /             # Destructive deletion
rm -rf ~             # Home deletion
rm -rf *             # Mass deletion
dd if=               # Disk operations
mkfs.*               # Format filesystem
curl ... | bash      # Download and execute
wget ... | bash      # Download and execute
chmod -R 777         # Overly permissive
```

---

## ⚡ Performance

| Operation | Time | Cached? |
|-----------|------|---------|
| Project Detection | 0.2s | ✅ |
| File Protection | 0.05s | ❌ |
| Bash Safety | 0.05s | ❌ |
| Quality Checks | 2-5s | ❌ |

**Total per file operation:** < 1 second overhead

---

## 📞 Quick Help

```bash
# Show installer help
~/.claude-code/install-hooks.sh --help

# Validate installation
ls -la .claude/hooks/
cat .claude/settings.json | python3 -m json.tool

# Test individual hook
bash .claude/hooks/session-start.sh < /dev/null

# Check hook is executable
ls -la .claude/hooks/*.sh
# Should show: -rwxr-xr-x
```

---

**Installation System:** `~/.claude-code/`
**Documentation:** `~/.claude-code/README.md`
**This Reference:** Always available in test project

---

*Keep this reference handy for quick lookups!*
