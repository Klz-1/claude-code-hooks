# Configure Hooks Skill

An interactive Claude skill for configuring Claude Code hooks and Git hooks through a conversational interface.

## 🎯 What This Skill Does

Instead of manually editing configuration files, this skill:

- ✅ Asks you questions about your preferences
- ✅ Explains what each option does
- ✅ Generates the right configuration
- ✅ Applies settings to your project
- ✅ Verifies everything works
- ✅ Shows you how to test it

## 🚀 How to Use

### Option 1: Using Skill Command

```bash
# In Claude Code, type:
skill: configure-hooks
```

### Option 2: Copy to Another Project

```bash
# Copy this skill to any project
cp -r .claude/skills/configure-hooks /path/to/other/project/.claude/skills/

# Then in Claude Code:
skill: configure-hooks
```

### Option 3: Install Globally

```bash
# Copy to global Claude directory
mkdir -p ~/.claude/skills
cp -r .claude/skills/configure-hooks ~/.claude/skills/

# Now available in all projects!
```

## 📋 What It Configures

### Claude Code Hooks

1. **Session Start**
   - Project detection
   - Tool availability checking
   - Environment setup

2. **File Protection**
   - Sensitive file patterns (.env, credentials, keys)
   - Custom patterns
   - Block or warn behavior

3. **Bash Safety**
   - Dangerous command patterns
   - Custom dangerous commands
   - Security policies

4. **Quality Checks**
   - Auto-format with Prettier
   - Auto-lint with ESLint
   - TypeScript type-checking
   - Error handling (block vs warn)

### Git Hooks

1. **Pre-Commit**
   - Secret scanning
   - Debug statement detection
   - File size limits
   - Linting and formatting
   - Type checking

2. **Commit Message**
   - Message length requirements
   - Conventional commits format
   - Issue/ticket references
   - Custom validation rules

3. **Pre-Push**
   - Protected branch confirmation
   - Force push blocking
   - Test suite execution
   - Build verification
   - Commit message validation

4. **Post-Checkout**
   - Branch awareness alerts
   - Dependency change detection
   - Protected branch warnings

5. **Post-Merge**
   - Auto dependency installation
   - Build artifact cleanup
   - Migration detection

6. **Pre-Rebase**
   - Protected branch safety
   - Public commit warnings
   - Working directory checks

## 🎨 Example Interaction

```
You: skill: configure-hooks

Claude: "Hi! I'll help you configure your development hooks.
         Let me ask you a few questions to customize them for your workflow."

Claude: [Shows question]
        "What would you like to configure?"
        ○ Claude Code hooks only
        ○ Git hooks only
        ● Both systems

You: [Select "Both systems"]

Claude: "Perfect! Let's start with Claude Code hooks..."

[Interactive Q&A continues]

Claude: "✅ Configuration complete!

         Here's what I configured:
         - File protection for .env files
         - Auto-formatting with Prettier
         - Pre-commit secret scanning
         - Pre-push tests

         Try making a commit to see it in action!"
```

## 🎓 What You'll Be Asked

### Initial Questions

1. **Scope**: What to configure (Claude Code, Git, or both)
2. **Level**: Quick setup (defaults) or custom configuration

### Claude Code Hooks Questions

- Which hooks to enable
- Protected file patterns
- Dangerous command patterns
- Quality check preferences
- Error handling (block vs warn)

### Git Hooks Questions

- Which hooks to enable
- Pre-commit check preferences
- Commit message requirements
- Pre-push validation rules
- Protected branch settings
- CI/CD environment variable overrides

### Customization Questions

- File size limits
- Message length requirements
- Custom patterns to add/remove
- Tool preferences (Prettier, ESLint, etc.)

## 💡 Tips

### For Beginners

1. Choose "Both systems" when asked
2. Use recommended defaults
3. Enable all suggested safety checks
4. Test with a practice commit

### For Teams

1. Configure once, then commit `.claude/` and `.githooks/` to git
2. Team members get same settings
3. Use reasonable defaults that won't frustrate team
4. Document any custom patterns

### For CI/CD

1. Enable environment variable overrides
2. Say "yes" when asked about non-interactive mode
3. The skill will configure ALLOW_MAIN_PUSH support
4. You'll get example GitHub Actions config

### For Advanced Users

1. Start with defaults, then customize
2. Run skill again to modify settings
3. Skills creates backups before changes
4. Can edit files directly after for fine-tuning

## 🔧 Advanced Usage

### Reconfiguring

```bash
# Run skill again to modify settings
skill: configure-hooks

# Skill will:
# - Show current configuration
# - Ask what you want to change
# - Preserve other settings
# - Create backup before changes
```

### Partial Configuration

The skill is smart about partial configs:

- Already have Claude Code hooks? Only configure Git hooks
- Only want to change file patterns? Just update that
- Need to add protected branch? Modify just that setting

### Backup and Restore

The skill automatically creates backups:

```bash
# Backups are timestamped
.claude/settings.json.backup.20251123
.githooks/pre-commit.backup.20251123

# To restore:
cp .claude/settings.json.backup.20251123 .claude/settings.json
```

## 📚 Related Documentation

After configuration, see:

- `README.md` - Complete hooks documentation
- `QUICK_REFERENCE.md` - One-page cheat sheet
- `GIT_HOOKS_GUIDE.md` - Git hooks integration
- `.githooks/README.md` - Detailed Git hooks docs
- `.githooks/CI_CD_GUIDE.md` - CI/CD configuration

## 🐛 Troubleshooting

### Skill Not Found

```bash
# Check skill is in correct location
ls -la .claude/skills/configure-hooks/

# Should see:
# skill.yaml
# prompt.md
# README.md
```

### Permission Denied

```bash
# Make sure directory is accessible
chmod -R 755 .claude/skills/
```

### Configuration Not Applied

The skill will:

1. Show what it's writing
2. Verify files were updated
3. Test basic functionality

If issues persist:

- Check file permissions
- Verify JSON syntax
- Run `.githooks/install.sh` manually

## 🎯 What Makes This Skill Special

### Compared to Manual Configuration

| Manual              | With Skill           |
| ------------------- | -------------------- |
| Edit multiple files | Answer questions     |
| Know JSON syntax    | Natural conversation |
| Read documentation  | Get explanations     |
| Trial and error     | Tested configuration |
| No validation       | Automatic validation |

### Compared to Install Scripts

| Install Script | This Skill           |
| -------------- | -------------------- |
| All or nothing | Granular control     |
| Fixed defaults | Custom preferences   |
| No explanation | Explains each option |
| One-time setup | Reconfigurable       |
| Generic        | Project-specific     |

## 📖 Skill Architecture

```
configure-hooks/
├── skill.yaml           # Manifest (name, version, description)
├── prompt.md           # Main skill logic (what you're reading)
└── README.md           # This file (documentation)
```

The `prompt.md` contains:

- **Instructions** for Claude on how to conduct the configuration
- **Question templates** using AskUserQuestion
- **Explanation guidelines** for helping users
- **Configuration generation** logic
- **Verification steps** to ensure it worked

## 🚀 Future Enhancements

Potential additions:

- [ ] Import/export configuration profiles
- [ ] Team presets (frontend, backend, fullstack)
- [ ] Language-specific defaults (Python, Go, Rust)
- [ ] Hook performance profiling
- [ ] Visual configuration dashboard
- [ ] Test mode (dry run without applying)

## 💬 Feedback

This skill makes hooks configuration approachable for everyone:

- **Beginners**: No need to understand hook internals
- **Teams**: Consistent setup across projects
- **Experts**: Faster than manual editing

Try it and see how much easier hook configuration becomes!

---

**Skill Version:** 1.0.0
**Last Updated:** 2025-11-23
**Compatibility:** Claude Code v1.0+
