# Claude Code Hooks Testing Project

This project is a test environment for Claude Code hooks that automate development workflows.

## 🎯 What This Project Tests

A comprehensive hooks system that:
- ✅ Detects project capabilities (TypeScript, tools, scripts)
- ✅ Blocks dangerous bash commands
- ✅ Protects sensitive files (.env, credentials, keys)
- ✅ Auto-formats code with Prettier after writes/edits
- ✅ Auto-lints code with ESLint
- ✅ Type-checks TypeScript files
- ✅ Suggests missing tools with installation commands

## 📁 Project Structure

```
.
├── .claude/
│   ├── hooks/
│   │   ├── utils/
│   │   │   ├── common.sh           # Shared utilities
│   │   │   └── detect-project.sh   # Project detection logic
│   │   ├── session-start.sh        # SessionStart hook
│   │   ├── pre-tool-protect.sh     # File protection (PreToolUse)
│   │   ├── pre-bash-safety.sh      # Bash safety (PreToolUse)
│   │   └── post-quality.sh         # Quality checks (PostToolUse)
│   └── settings.json               # Hook configuration
├── src/
│   ├── index.ts                    # Sample TypeScript code
│   └── index.test.ts               # Sample Jest tests
├── package.json                    # Project config with dev tools
├── tsconfig.json                   # TypeScript config
├── .eslintrc.json                  # ESLint config
├── .prettierrc.json                # Prettier config
└── jest.config.js                  # Jest config
```

## 🚀 Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

This installs:
- TypeScript compiler
- ESLint + TypeScript plugin
- Prettier
- Jest + ts-jest
- Type definitions

### 2. Verify Hook Scripts Are Executable

```bash
chmod +x .claude/hooks/*.sh .claude/hooks/utils/*.sh
```

### 3. Test Project Detection

```bash
bash .claude/hooks/utils/detect-project.sh
```

Expected output:
```
[INFO] Project Type: javascript
[INFO] Has TypeScript: true
[INFO] Available Tools:
  - prettier: true
  - eslint: true
  - jest: true
  - tsc: true
```

## 🧪 Testing the Hooks

### Test 1: SessionStart Hook
**Tests:** Project detection and environment setup

```bash
# Simulate SessionStart hook
echo '{"source": "startup"}' | bash .claude/hooks/session-start.sh
```

**Expected:** JSON output with project capabilities and available tools

---

### Test 2: File Protection (PreToolUse)
**Tests:** Blocking writes to sensitive files

```bash
# Try to modify .env file (should be blocked)
echo '{
  "tool_name": "Write",
  "tool_input": {
    "file_path": ".env"
  }
}' | bash .claude/hooks/pre-tool-protect.sh
```

**Expected:** JSON with `permissionDecision: "deny"` and reason about protected files

```bash
# Try to modify normal file (should be allowed)
echo '{
  "tool_name": "Write",
  "tool_input": {
    "file_path": "src/index.ts"
  }
}' | bash .claude/hooks/pre-tool-protect.sh
```

**Expected:** JSON with `permissionDecision: "allow"`

---

### Test 3: Bash Safety (PreToolUse)
**Tests:** Blocking dangerous bash commands

```bash
# Try dangerous command (should be blocked)
echo '{
  "tool_name": "Bash",
  "tool_input": {
    "command": "rm -rf /"
  }
}' | bash .claude/hooks/pre-bash-safety.sh
```

**Expected:** JSON with `permissionDecision: "deny"`

```bash
# Try safe command (should be allowed)
echo '{
  "tool_name": "Bash",
  "tool_input": {
    "command": "ls -la"
  }
}' | bash .claude/hooks/pre-bash-safety.sh
```

**Expected:** JSON with `permissionDecision: "allow"`

---

### Test 4: Quality Checks (PostToolUse)
**Tests:** Auto-formatting and linting after file edits

First, create a poorly formatted test file:

```bash
cat > src/test-bad-format.ts << 'EOF'
export function poorlyFormatted(x:number,y:number){const result=x+y;return result}
EOF
```

Then run the quality hook:

```bash
echo '{
  "tool_name": "Write",
  "tool_input": {
    "file_path": "src/test-bad-format.ts"
  }
}' | bash .claude/hooks/post-quality.sh
```

**Expected:**
- File gets auto-formatted by Prettier
- ESLint runs with --fix
- TypeScript type-checks the file
- JSON output reports what was done

Check the file was formatted:
```bash
cat src/test-bad-format.ts
```

---

### Test 5: End-to-End with Claude Code

**Important:** These hooks will automatically run when you use Claude Code in this project!

Try these commands with Claude Code:

1. **Test SessionStart:**
   - Start a new Claude Code session in this directory
   - You should see project detection info in the output

2. **Test File Protection:**
   - Ask Claude: "Create a .env file with some test variables"
   - Should be blocked by the pre-tool-protect hook

3. **Test Bash Safety:**
   - Ask Claude: "Run rm -rf / to clean up"
   - Should be blocked by the pre-bash-safety hook

4. **Test Quality Checks:**
   - Ask Claude: "Add a new function to src/index.ts"
   - After writing, Prettier and ESLint should run automatically
   - If there are errors, the hook should block and report them

5. **Test Missing File Type:**
   - Ask Claude: "Create a new file src/data.json"
   - Quality hooks should run but skip formatting (JSON not configured)

## 🔧 Hook Configuration

Hooks are configured in `.claude/settings.json`:

- **SessionStart**: Runs `session-start.sh` when session starts
- **PreToolUse** (Write/Edit): Runs `pre-tool-protect.sh` before file modifications
- **PreToolUse** (Bash): Runs `pre-bash-safety.sh` before bash commands
- **PostToolUse** (Write/Edit): Runs `post-quality.sh` after file modifications

## 🛠️ Customization

### Adding Protected File Patterns

Edit `.claude/hooks/pre-tool-protect.sh` and add patterns to `PROTECTED_PATTERNS`:

```bash
PROTECTED_PATTERNS=(
    '\\.env$'
    'my-custom-secret\\.json$'
    # Add more patterns here
)
```

### Adding Dangerous Command Patterns

Edit `.claude/hooks/pre-bash-safety.sh` and add patterns to `DANGEROUS_PATTERNS`:

```bash
DANGEROUS_PATTERNS=(
    'rm\s+-rf\s+/'
    'my-dangerous-command'
    # Add more patterns here
)
```

### Adjusting Quality Checks

Edit `.claude/hooks/post-quality.sh` to:
- Change timeout values
- Add/remove linters
- Modify error handling
- Add custom validators

## 📊 Testing Checklist

- [ ] Dependencies installed (`npm install`)
- [ ] Scripts are executable (`chmod +x`)
- [ ] Project detection works
- [ ] SessionStart hook outputs project info
- [ ] File protection blocks .env files
- [ ] File protection allows normal files
- [ ] Bash safety blocks `rm -rf /`
- [ ] Bash safety allows `ls`
- [ ] Quality checks format with Prettier
- [ ] Quality checks lint with ESLint
- [ ] Quality checks type-check TypeScript
- [ ] Quality checks block on errors
- [ ] End-to-end test with Claude Code

## 🎓 What You Learned

After testing, you'll understand:
1. How to structure hook scripts for reusability
2. How to detect project capabilities dynamically
3. How to block dangerous operations
4. How to auto-format and lint code
5. How to provide feedback to Claude
6. How to make hooks fail-safe (graceful degradation)

## 🚀 Next Steps

Once testing is complete, you can:
1. Copy `.claude/hooks/` to other projects
2. Create an installation script for easy deployment
3. Customize hooks per project type
4. Add more hooks (tests, builds, git operations)
5. Share with your team

## 📝 Notes

- Hooks run synchronously and can slow down operations if too complex
- Always exit with code 0 for success, 2 for blocking
- Use JSON output for structured feedback to Claude
- Test hooks manually before relying on them in production
