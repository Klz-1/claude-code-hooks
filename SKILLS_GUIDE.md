# 🎨 Configure Hooks Skill Guide

## 🎯 What Is This?

An **interactive Claude skill** that configures your hooks through conversation instead of manual file editing.

Think of it as a **guided setup wizard** that:

- Asks you questions about your preferences
- Explains what each option does
- Generates the right configuration automatically
- Tests that everything works

---

## 🚀 Quick Start

### Step 1: Invoke the Skill

In Claude Code, simply type:

```
skill: configure-hooks
```

### Step 2: Answer Questions

Claude will ask you questions like:

```
Which hooks would you like to enable?
☑ File protection (.env, credentials)
☑ Auto-format with Prettier
☑ Secret scanning
☐ Debug statement detection
```

### Step 3: Review & Apply

Claude shows you what will be configured and applies it automatically.

### Step 4: Test

Claude tells you how to test your new configuration.

---

## 📋 What Gets Configured

### Claude Code Hooks

- ✅ Session start (project detection)
- ✅ File protection (sensitive files)
- ✅ Bash safety (dangerous commands)
- ✅ Quality checks (format, lint, type-check)

### Git Hooks

- ✅ Pre-commit (quality gate)
- ✅ Commit message (validation)
- ✅ Pre-push (comprehensive checks)
- ✅ Post-checkout (branch awareness)
- ✅ Post-merge (auto-install deps)
- ✅ Pre-rebase (safety checks)

---

## 🎓 Example Walkthrough

### Complete Interaction

```
👤 You: skill: configure-hooks

🤖 Claude: Hi! I'll help you configure your development hooks.
          Let me ask you a few questions to customize them for your workflow.

          What would you like to configure?
          ○ Claude Code hooks only
          ○ Git hooks only
          ● Both systems (recommended)

👤 You: [Select "Both systems"]

🤖 Claude: Perfect! Let's start with Claude Code hooks.

          Which Claude Code hooks should be enabled?
          ● Session start - Detect tools and project type
          ● File protection - Block editing .env, credentials
          ● Bash safety - Prevent dangerous commands
          ● Quality checks - Auto-format and lint code

👤 You: [Select all]

🤖 Claude: Great choices! For file protection, which patterns should be protected?

          Protected file patterns:
          ● .env, .env.local, .env.*
          ● credentials.json, secrets.json
          ● *.key, *.pem, *.p12
          ○ Add custom patterns

👤 You: [Select defaults]

🤖 Claude: Excellent! Now for quality checks...

          How should quality checks behave?
          ○ Block commits with errors (strict)
          ● Warn about issues but allow (permissive)

👤 You: [Select "Block with errors"]

🤖 Claude: Perfect! Moving to Git hooks...

          Which Git hooks should be enabled?
          ● Pre-commit - Scan secrets, format code
          ● Pre-push - Run tests and build
          ● Post-checkout - Show branch status
          ○ Post-merge - Auto-install dependencies
          ○ Commit-msg - Validate message format
          ○ Pre-rebase - Safety checks

👤 You: [Select first three]

🤖 Claude: Great! For pre-commit checks...

          What should run before each commit?
          ● Scan for secrets (API keys, passwords)
          ● Check for debug statements (console.log)
          ● Auto-format with Prettier
          ● Auto-lint with ESLint
          ● TypeScript type-check
          ○ Check file sizes (max 5MB)

👤 You: [Select all]

🤖 Claude: For pre-push validation...

          When pushing to main/master:
          ● Ask for confirmation
          ● Block force pushes
          ● Run test suite (if configured)
          ● Run build (if configured)

          Enable environment variable overrides for CI/CD?
          (Allows ALLOW_MAIN_PUSH=1 in automation)
          ● Yes (recommended for CI/CD)
          ○ No

👤 You: [Select "Yes"]

🤖 Claude: Perfect! Here's what I'm going to configure:

          **Claude Code Hooks:**
          ✓ Session start enabled
          ✓ File protection (.env, credentials, keys)
          ✓ Bash safety (rm -rf, etc.)
          ✓ Quality checks (block on errors)
            - Auto-format with Prettier
            - Auto-lint with ESLint
            - Type-check TypeScript

          **Git Hooks:**
          ✓ Pre-commit
            - Secret scanning
            - Debug statement detection
            - Prettier auto-format
            - ESLint auto-fix
            - TypeScript type-check
            - File size validation (5MB)

          ✓ Pre-push
            - Main/master confirmation
            - Force push blocking
            - Test suite execution
            - Build verification
            - CI/CD env var support (ALLOW_MAIN_PUSH=1)

          ✓ Post-checkout
            - Branch status display
            - Protected branch warnings
            - Dependency change detection

          Let me apply these settings...

          [Writing configurations...]

          ✅ Configuration complete!

          **Files updated:**
          - .claude/settings.json
          - .claude/hooks/pre-tool-protect.sh
          - .claude/hooks/post-quality.sh
          - .githooks/pre-commit
          - .githooks/pre-push
          - .githooks/post-checkout

          **Git hooks installed:**
          ✓ Git configured to use .githooks/
          ✓ All scripts made executable
          ✓ 3 hooks active

          **To test:**
          1. Try editing .env file:
             echo "SECRET=test" > .env
             # Should be blocked by Claude Code

          2. Make a test commit:
             echo "test" > test.txt
             git add test.txt
             git commit -m "test"
             # Will auto-format, scan for secrets

          3. Try pushing to main:
             git push origin main
             # Will ask for confirmation

          4. Test CI/CD override:
             ALLOW_MAIN_PUSH=1 git push origin main
             # Will skip confirmation

          **To modify later:**
          - Run this skill again: skill: configure-hooks
          - Or edit files directly in .claude/hooks/ and .githooks/

          **Documentation:**
          - Quick reference: QUICK_REFERENCE.md
          - Git hooks guide: GIT_HOOKS_GUIDE.md
          - CI/CD guide: .githooks/CI_CD_GUIDE.md

          Your hooks are ready to use! 🎉
```

---

## 💡 Usage Scenarios

### Scenario 1: First-Time Setup

**Situation:** You just cloned this repo and want to set up hooks

**Steps:**

1. `skill: configure-hooks`
2. Select "Both systems"
3. Choose recommended defaults
4. Test with a commit

**Time:** ~2 minutes

---

### Scenario 2: Reconfiguring Existing Hooks

**Situation:** You want to change file size limit from 5MB to 10MB

**Steps:**

1. `skill: configure-hooks`
2. Skill shows current config
3. Select "Modify existing"
4. Choose "Pre-commit settings"
5. Update file size limit
6. Apply changes

**Time:** ~1 minute

---

### Scenario 3: Team Setup

**Situation:** Setting up hooks for your whole team

**Steps:**

1. `skill: configure-hooks`
2. Use "Team-friendly" preset
3. Review settings with team
4. Commit .claude/ and .githooks/ to git
5. Team runs `npm install` (hooks auto-install)

**Time:** ~5 minutes (including team review)

---

### Scenario 4: CI/CD Configuration

**Situation:** Need hooks to work in GitHub Actions

**Steps:**

1. `skill: configure-hooks`
2. Select Git hooks
3. Enable "CI/CD environment variable overrides"
4. Skill generates example GitHub Actions config
5. Copy to .github/workflows/

**Time:** ~3 minutes

---

## 🎨 Skill Features

### Smart Defaults

The skill knows recommended settings:

- ✅ Marks recommended options
- ✅ Explains why they're recommended
- ✅ Allows customization if needed

### Context Awareness

The skill adapts to your project:

- Detects if hooks already installed
- Shows current configuration
- Only asks about changes
- Preserves settings you don't modify

### Validation

The skill ensures correctness:

- ✅ Validates JSON syntax
- ✅ Tests file permissions
- ✅ Verifies git config
- ✅ Checks executability

### Backup Safety

The skill protects your data:

- Creates timestamped backups
- Shows what will change
- Allows rollback if needed

---

## 📚 Comparison: Skill vs Manual

| Aspect                | Manual Configuration                     | Configure Hooks Skill       |
| --------------------- | ---------------------------------------- | --------------------------- |
| **Learning curve**    | High (need to understand hook internals) | Low (just answer questions) |
| **Time to configure** | 15-30 minutes                            | 2-5 minutes                 |
| **Errors**            | Easy to make syntax errors               | Validated automatically     |
| **Explanation**       | Read docs yourself                       | Explained as you go         |
| **Reconfiguration**   | Edit multiple files                      | Run skill again             |
| **Testing**           | Manual verification                      | Guided testing              |
| **Team onboarding**   | Share documentation                      | Run skill with same answers |

---

## 🔧 Advanced Features

### Configuration Profiles

The skill can save/load profiles:

```
🤖 Claude: I see you've configured hooks before.
          Would you like to:
          ○ Use previous configuration
          ○ Start fresh
          ○ Modify previous configuration

👤 You: [Select "Modify previous"]

🤖 Claude: Your current configuration:
          - File protection: enabled
          - Auto-format: enabled
          - Pre-commit: enabled
          - Pre-push: enabled

          What would you like to change?
```

### Preset Templates

The skill offers presets:

```
🤖 Claude: Quick setup or custom?
          ○ Beginner (recommended defaults)
          ○ Team (balanced for collaboration)
          ○ Strict (maximum safety)
          ○ Minimal (essential only)
          ○ Custom (full control)
```

### Partial Updates

Update just one aspect:

```
🤖 Claude: What would you like to configure?
          ○ Add protected file pattern
          ○ Change file size limit
          ○ Enable/disable specific hook
          ○ Update commit message rules
          ○ Full reconfiguration
```

---

## 🐛 Troubleshooting

### Skill Not Working

```bash
# Check skill exists
ls -la .claude/skills/configure-hooks/

# Should see:
# skill.yaml
# prompt.md
# README.md
```

### Permission Issues

```bash
# Fix permissions
chmod -R 755 .claude/skills/
```

### Configuration Not Applied

Skill will show what it tried to write. If issues:

1. Check file permissions
2. Verify JSON syntax
3. Re-run skill with --force

---

## 📖 Installation for Other Projects

### Copy to Specific Project

```bash
cp -r .claude/skills/configure-hooks /path/to/project/.claude/skills/

# Then in that project:
skill: configure-hooks
```

### Install Globally

```bash
# Copy to global Claude directory
mkdir -p ~/.claude/skills
cp -r .claude/skills/configure-hooks ~/.claude/skills/

# Now available in ALL projects!
```

---

## 🎓 How It Works

### Under the Hood

1. **Skill Invocation**
   - You type `skill: configure-hooks`
   - Claude loads `prompt.md`
   - Skill instructions activate

2. **Question Flow**
   - Uses `AskUserQuestion` tool
   - Presents clear options
   - Gathers preferences

3. **Configuration Generation**
   - Builds settings.json structure
   - Modifies hook scripts
   - Validates all changes

4. **Application**
   - Creates backups
   - Writes configurations
   - Sets permissions
   - Installs git hooks

5. **Verification**
   - Tests file permissions
   - Validates JSON
   - Checks git config
   - Confirms installation

---

## 💬 Tips & Tricks

### For Beginners

✅ **DO:**

- Use recommended defaults
- Enable all safety checks
- Test after configuration
- Read the provided examples

❌ **DON'T:**

- Skip explanations
- Disable recommended features
- Apply without testing

### For Teams

✅ **DO:**

- Use "Team" preset
- Test before committing
- Document custom patterns
- Share configuration reasons

❌ **DON'T:**

- Use overly strict settings
- Skip team discussion
- Forget to document

### For Advanced Users

✅ **DO:**

- Start with skill for base config
- Fine-tune files afterward
- Create custom presets
- Document modifications

❌ **DON'T:**

- Skip skill entirely (it's faster!)
- Over-customize on first setup
- Forget to backup

---

## 🎯 Success Metrics

You'll know the skill worked when:

- ✅ You understand what each setting does
- ✅ Configuration matches your needs
- ✅ Hooks run without errors
- ✅ Team members can use same setup
- ✅ CI/CD pipelines work correctly
- ✅ You can modify settings easily

---

## 🚀 Future Enhancements

Planned features:

- [ ] Visual configuration dashboard
- [ ] Import/export profiles (JSON)
- [ ] Language-specific presets (Python, Go, Rust)
- [ ] Performance profiling mode
- [ ] Dry-run mode (preview without applying)
- [ ] Conflict resolution helper
- [ ] Auto-update check

---

## 📝 Feedback

This skill makes hooks configuration:

- **10x faster** than manual editing
- **100% validated** automatically
- **Fully explained** during setup
- **Easily modifiable** anytime

Try it and experience the difference!

---

**Skill Location:** `.claude/skills/configure-hooks/`
**Version:** 1.0.0
**Compatibility:** Claude Code v1.0+
**Documentation:** See skill's README.md for details
