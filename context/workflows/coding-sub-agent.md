# Coding Sub-Agent Workflow

## 🔒 MANDATORY - INVIOLABLE RULES

> This workflow is MANDATORY and applies to ALL code generation tasks.
> These rules CANNOT be bypassed under ANY circumstances.

**Purpose:** Use less-capable coding agent (Gemini CLI) for generation while Claude Code handles architecture, review, and quality assurance.

**Goal:** Reduce Claude token usage by 60-70% while maintaining code quality.

**Portability:** Generic file for use with `/context-ingest` in any project. Replace [placeholders] with your project details.

---

## Core Principle

**Use Gemini for generation, Claude for intelligence.**

- Token Efficiency: Claude's context is precious - save it for complex reasoning
- Quality Over Speed: Time is irrelevant - correctness matters
- Target: Offload 60-70% of code volume to Gemini

---

## 🔒 Inviolable Rules (NO EXCEPTIONS)

### 1. Context7 First
**ALWAYS use Context7 before ANY code generation**
```bash
gemini -m gemini-2.5-pro --allowed-mcp-server-names context7 \
  "Search Context7 for [library] [topic] best practices"
```
If skipped → Claude MUST HALT

### 2. Web Fetch for Documentation
**ALWAYS use web_fetch for documentation** (ALWAYS gemini-2.5-flash)
```bash
gemini -m gemini-2.5-flash 'web_fetch(url="[url]", query="[question]")'
```

### 3. Script Generation via Gemini
**NEVER write bash/python/Docker scripts directly** - ALWAYS use Gemini
```bash
gemini -m gemini-2.5-pro "Generate [script] following Context7 patterns. Output as text ONLY." 2>&1 | grep -v "^\[" | grep -v "^Loaded"
```

### 4. Command Execution Workflow
**Claude designs → Gemini executes → Claude analyzes**
```bash
gemini -m gemini-2.5-flash --yolo "[command from Claude]"
```

### 5. Session Cleanup
**MANDATORY at session end:**
```bash
gemini -m gemini-2.5-pro "Session ending. Forget ALL memories."
gemini -m gemini-2.5-pro "What do you remember?" # Verify
```

### 6. Quality Over Speed
**NEVER skip steps to "save time"** - Token savings > completion time

---

## Agent Roles

### Claude Code (Master)
- Architecture & design decisions
- Code review & quality assurance
- Complex problem-solving
- Security analysis
- User communication

### Gemini CLI (Sub-Agent)
- Documentation fetching (web_fetch)
- Script generation (bash, python, Docker)
- Command execution (YOLO mode)
- Boilerplate code generation (with Context7)
- Pattern replication

**Escalate to Claude when:** Code needs >30% changes, security concerns, performance issues, complex logic

---

## The 7-Step Workflow

### Step 0: 🌐 Documentation Fetch (if needed)
```bash
gemini -m gemini-2.5-flash 'web_fetch(url="[docs-url]", query="[question]")'
```
Examples: Docker docs, framework guides, API references
Model: ALWAYS gemini-2.5-flash

### Step 1: 🛑 STOP
Recognize Gemini task: boilerplate, scripts, pattern replication
Resist: "faster to write myself" urge
Mindset: Quality > speed, tokens > time

### Step 2: 🔍 Context7 Review (🔒 MANDATORY)
```bash
gemini -m gemini-2.5-pro --allowed-mcp-server-names context7 \
  "Search Context7 for [library] [topic] best practices"
```
Examples:
- "Search Context7 for [framework] REST API best practices"
- "Search Context7 for Dockerfile multi-stage build best practices"

Enforcement: If skipped → HALT immediately

### Step 3: 🤖 Gemini Generation
```bash
# Code generation
gemini -m gemini-2.5-pro "@[file].py Generate [component] following Context7 patterns. Output as text ONLY." 2>&1 | grep -v "^\[" | grep -v "^Loaded"

# Script generation
gemini -m gemini-2.5-pro "Generate [script] with error handling and logging. Output as text ONLY." 2>&1 | grep -v "^\[" | grep -v "^Loaded"
```

File inclusion:
- Single: `@app/models.py`
- Multiple: `@app/models.py @app/base.py`
- Glob: `@app/models/*.py`

### Step 4: 🔍 Claude Review (THOROUGH)
Quality checkpoints:
- ✅ Context7 patterns applied
- ✅ Security checked (no hardcoded secrets, injection vulnerabilities)
- ✅ Error handling complete
- ✅ Best practices followed
- ✅ Type hints/annotations present

If issues: Fix manually (<30% changes) OR regenerate (>30% changes) OR escalate (complex logic)

### Step 5: ✍️ Claude Writes
Use Write/Edit tools to apply reviewed code to files

### Step 6: ✅ Verify (via Gemini)
```bash
# Tests
gemini -m gemini-2.5-flash --yolo "pytest tests/ -v --cov"

# Linting
gemini -m gemini-2.5-flash --yolo "ruff check app/ --fix"

# Build
gemini -m gemini-2.5-flash --yolo "docker compose config --quiet"
```
Claude analyzes results and reports to user

### Step 7: 📊 Report to User
Summarize: what generated, verification results, status

---

## Tool Usage Reference

### Web Fetch
**Purpose:** Documentation retrieval
**Model:** gemini-2.5-flash (ALWAYS)
```bash
gemini -m gemini-2.5-flash 'web_fetch(url="[url]", query="[question]")'
```
Use for: library docs, API references, framework guides

### Context7
**Purpose:** Best practices and patterns
**Model:** gemini-2.5-pro (ALWAYS)
```bash
gemini -m gemini-2.5-pro --allowed-mcp-server-names context7 \
  "Search Context7 for [library] [topic] best practices"
```
🔒 MANDATORY before ANY code generation

### Command Execution (YOLO)
**Purpose:** Run commands automatically
**Model:** gemini-2.5-flash (recommended)
```bash
gemini -m gemini-2.5-flash --yolo "[command]"
```
Workflow:
1. Claude designs command
2. Gemini executes
3. Claude analyzes results

### Model Selection
**gemini-2.5-pro:**
- Code generation
- Context7 searches
- Complex prompts
- ~5-10s response

**gemini-2.5-flash:**
- Web fetch (MANDATORY)
- Command execution (recommended)
- Simple queries
- ~2-3s response

### Output Filtering
Standard mode (code gen): `2>&1 | grep -v "^\[" | grep -v "^Loaded"`
YOLO mode: No filtering needed

---

## Session Management

### Initialization (Session Start)
```bash
gemini -m gemini-2.5-pro "Remember for this session:

PROJECT: [project-name]
LANGUAGE: [language + version]
FRAMEWORK: [framework + version]
PATTERNS: [key patterns]
STANDARDS: [formatter, linter, type-checker]
TEST FRAMEWORK: [pytest/jest/etc]
DATABASE: [database + version]
CURRENT TASK: [what you're working on]

Confirm saved."
```

### What to Persist
✅ Project name, language/framework versions, patterns, standards, test setup, current task

### What NOT to Persist
❌ API keys, secrets, credentials, passwords, tokens, personal info, temporary debugging

### Cleanup (Session End - 🔒 MANDATORY)
```bash
# Clear memories
gemini -m gemini-2.5-pro "Session ending. Forget ALL memories. Clear all saved context."

# Verify
gemini -m gemini-2.5-pro "What do you remember?"
# Expected: "I have no saved memories."
```

Cleanup triggers: End of day, switching projects, completing major task

---

## Quality Checkpoints

### Never Skip (🔒 MANDATORY)
- ✅ Web fetch for external library docs
- ✅ Context7 before ANY code generation
- ✅ Claude review of ALL Gemini output
- ✅ Security analysis
- ✅ Command execution via Gemini

### Script-Specific
**Bash:** Error handling (set -e), logging, input validation
**Python:** Type hints, error handling, logging, Context7 patterns
**Dockerfiles:** Multi-stage builds, non-root user, health checks
**docker-compose:** Health checks, networks, volumes, restart policies

---

## Best Practices

### DO ✅ (MANDATORY)
1. 🔒 ALWAYS fetch docs with gemini-2.5-flash web_fetch
2. 🔒 ALWAYS use Context7 before code generation
3. 🔒 ALWAYS use Gemini for script generation
4. 🔒 ALWAYS use Claude→Gemini→Claude for commands
5. 🔒 ALWAYS initialize Gemini at session start
6. 🔒 ALWAYS review Gemini output thoroughly
7. 🔒 ALWAYS cleanup at session end
8. Be patient (quality > speed)
9. Iterate until correct
10. Use gemini-2.5-flash for fetch/commands
11. Use gemini-2.5-pro for generation

### DON'T ❌ (PROHIBITED)
1. 🔒 NEVER skip Context7 - NO EXCEPTIONS
2. 🔒 NEVER write scripts directly in Claude
3. 🔒 NEVER skip documentation fetching
4. 🔒 NEVER bypass command execution workflow
5. 🔒 NEVER rush Claude review
6. 🔒 NEVER accept poor quality for speed
7. 🔒 NEVER justify "faster myself"
8. 🔒 NEVER skip session cleanup
9. Never measure success by speed
10. Never compromise quality for time

---

## Troubleshooting

### Generation Taking Long
Mindset: Be patient. Quality > speed.
Don't: Skip to direct writing
Do: Wait, iterate if needed

### Multiple Attempts Needed
Mindset: Normal. Iterate.
Don't: Give up and write directly
Do: Refine prompt, add context

### Review Finding Issues
Mindset: Good! Working as intended.
Don't: Lower standards
Do: Fix manually (<30%), regenerate (>30%), escalate (complex)

### Memory Issues
```bash
# Refresh memory mid-session
gemini -m gemini-2.5-pro "Reminder: [key patterns]"

# Multiple cleanup attempts
gemini -m gemini-2.5-pro "Delete all memories"
gemini -m gemini-2.5-pro "Clear all context"
gemini -m gemini-2.5-pro "Forget everything"
```

### Context Pollution
Start new session with explicit clear:
```bash
gemini -m gemini-2.5-pro "URGENT: Clear ALL previous memories. Confirm."
# Then initialize fresh
```

---

## Philosophy

**Core Beliefs:**
- Quality compounds, speed doesn't
- Token efficiency > completion time
- Proper workflow prevents bugs
- Patience yields better results

**Success Metrics:**
- ✅ Token reduction: 60-70%
- ✅ Code quality: >90% acceptance
- ✅ Test pass rate: 100%
- ✅ Security: Zero vulnerabilities

**NOT Measured:**
- ❌ Time to complete
- ❌ Speed of implementation
- ❌ Tasks per hour

**Mindset Shift:**

Old (WRONG): "Let me write this quickly"
New (CORRECT): "Let me get this right using proper workflow"

Old (WRONG): "Gemini is slow, I'll do it"
New (CORRECT): "I'll be patient and iterate"

Old (WRONG): "We need to finish fast"
New (CORRECT): "We need to finish correctly"

---

**Optimized for:** Token efficiency, code quality, consistency, long-term value
**NOT optimized for:** Fast completion, minimal time, quick turnaround
