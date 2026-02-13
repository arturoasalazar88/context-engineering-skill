# Context Engineering Skill for Claude Code

A set of Claude Code slash commands that implement context engineering best practices for any project. Initialize projects with optimal context structure, ingest new context intelligently, and manage sessions with proper context loading.

---

## Table of Contents

- [What Is This?](#what-is-this)
- [Quick Start](#quick-start)
- [Installation](#installation)
  - [New Project](#new-project)
  - [Existing Project](#existing-project)
- [Commands](#commands)
- [What Gets Created](#what-gets-created)
- [How It Works](#how-it-works)
- [Customization](#customization)
- [Uninstall](#uninstall)
- [Documentation](#documentation)
- [Requirements](#requirements)
- [License](#license)

---

## What Is This?

Four Claude Code slash commands that automate context engineering:

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/context-init` | Initialize project with context engineering | Once, at project setup |
| `/context-ingest` | Add new context intelligently | Anytime you have new info to add |
| `/context-start` | Start session with proper context loading | Beginning of every session |
| `/context-refactor` | Audit and refactor existing implementation | When upgrading or fixing issues |

**Context engineering** is a set of principles for managing AI agent context effectively:
- Keep always-loaded context minimal (<2,500 tokens)
- Load information progressively (only what's needed)
- Use structured formats (tables, key-value) instead of prose
- Isolate credentials in a single protected file
- Track work through stories with checklists

These principles were developed through real-world usage, reducing static context from 33K to 2K tokens (94% reduction) while improving agent effectiveness.

---

## Quick Start

```bash
# 1. Get the skill
git clone https://github.com/arturoasalazar88/context-engineering-skill.git
cd context-engineering-skill

# 2. Run the installer
./install.sh
# (Enter your project path when prompted)

# 3. Open your project in Claude Code and run:
/context-init
```

---

## Installation

### Automated Installation (Recommended)

**Step 1: Get the skill**

```bash
git clone https://github.com/arturoasalazar88/context-engineering-skill.git
cd context-engineering-skill
```

**Step 2: Run the installer**

```bash
./install.sh
```

The installer will:
- Ask for your target project path
- Detect your agent tool (Claude Code, etc.)
- Install all 4 commands to the appropriate directory
- Copy skill files (templates, docs) to your project
- Verify installation and show next steps

**Step 3: Initialize your project**

Open your project in Claude Code and run:
```
/context-init
```

### Manual Installation

If you prefer manual installation or need to troubleshoot:

**Step 1: Copy skill to your project**

```bash
cp -r context-engineering-skill/ /path/to/your-project/
```

**Step 2: Install commands**

```bash
cd /path/to/your-project
mkdir -p .claude/commands
cp context-engineering-skill/commands/*.md .claude/commands/
```

**Step 3: Verify**

```bash
ls .claude/commands/context-*.md
```

Expected: 4 files (context-init.md, context-ingest.md, context-refactor.md, context-start.md)

**Step 4: Initialize**

Open in Claude Code and run: `/context-init`

### Upgrading Existing Installation

If you already have context engineering and want to add the new `/context-refactor` command:

```bash
cd context-engineering-skill
./install.sh
# Enter your project path
# Choose to overwrite when prompted
```

Or manually:
```bash
cp context-engineering-skill/commands/context-refactor.md /path/to/project/.claude/commands/
```

### Verify Everything Works

After installation, verify these commands are available in Claude Code:

| Command | Test |
|---------|------|
| `/context-init` | Should start interactive wizard |
| `/context-ingest` | Should ask for content type |
| `/context-start` | Should report context status |

---

## Commands

### `/context-init` - Project Initialization

Interactive wizard that creates the complete context engineering structure.

**What it asks:**
1. Project name, purpose, and languages
2. Single vs multi-component project
3. Server/infrastructure details
4. Technical documents to process
5. Context onboarding (free-form project description)
6. Optional workflow rules

**What it creates:**
- `CLAUDE.md` - Project context entry point (<150 lines)
- `.claude/rules/` - Agent rule files (3 files)
- `context/` - Domain knowledge files
- `context/stories/` - Story tracking system
- `context/workflows/` - Workflow rules
- Initial stories from provided documents

See [docs/commands-reference.md](docs/commands-reference.md) for the full flow.

### `/context-ingest` - Smart Context Ingestion

Analyzes content and places it in the correct location automatically.

**Content types handled:**
- Stories/Tasks -> `context/stories/BACKLOG-XXX.md`
- Technical docs -> `context/[DOMAIN].md`
- Workflow rules -> `context/workflows/` or `.claude/rules/`
- System info -> `context/SYSTEM.md`
- Project context -> CLAUDE.md sections

**Features:**
- Auto-categorizes content type
- Converts prose to structured format (tables, checklists)
- Previews placement before creating files
- Reports token budget impact
- Never puts credentials outside SYSTEM.md

See [docs/commands-reference.md](docs/commands-reference.md) for the decision tree.

### `/context-start` - Session Management

Automates the beginning of every work session.

**What it does:**
1. Loads CLAUDE.md and all rule files
2. Calculates token budget and reports zone status
3. Shows active stories from INDEX.md
4. Lets you select a story to work on
5. Reports session readiness

**Zone system:**
| Zone | Tokens | Action |
|------|--------|--------|
| Green | 0-100K | Normal work |
| Yellow | 100K-140K | Monitor usage |
| Red | 140K-160K | End session soon |
| Critical | 160K+ | End immediately |

See [docs/commands-reference.md](docs/commands-reference.md) for the full flow.

### `/context-refactor` - Implementation Audit & Refactor

Audits an existing context engineering implementation and refactors it to match best practices.

**What it audits:**
1. Security (credentials, API keys, passwords)
2. Structure (required files, naming conventions)
3. Token budget (CLAUDE.md size, total always-loaded)
4. Format (tables vs prose, structured data)
5. Story system (naming, metadata, INDEX.md)

**Modes:**
- `--report-only` - Generate audit report without changes
- `--auto` - Automatically apply all safe fixes
- Interactive (default) - Review each fix before applying

**What it fixes:**
- Missing rule files (created from templates)
- Wrong file naming (story files renamed to standard)
- Missing metadata blocks
- Token budget violations (suggests content moves)
- Security issues (guides credential relocation)

**Features:**
- Always creates backups before modifications
- Compares against canonical templates
- Provides detailed severity-based report
- Safe fixes applied automatically, risky ones need approval
- Re-audits after fixes to verify

**Use cases:**
- Upgrading old context engineering setup
- Auditing compliance with best practices
- Fixing structural issues
- Preparing for team adoption

See [docs/commands-reference.md](docs/commands-reference.md) for detailed audit checks and examples.

---

## What Gets Created

After running `/context-init`, your project will have this structure:

```
your-project/
  CLAUDE.md                               # Project context (<150 lines)
  .claude/
    commands/
      context-init.md                     # /context-init command
      context-ingest.md                   # /context-ingest command
      context-start.md                    # /context-start command
    rules/
      core-rules.md                       # 7 mandatory agent rules
      context-enforcement.md              # Session checklists
      context-window-monitoring.md        # Token usage monitoring
  context/
    CONTEXT-SCHEMA.yaml                   # What loads when (token budgets)
    MEMORY-PROTOCOL.md                    # Memory management guide
    SYSTEM.md                             # Server info & credentials
    stories/
      INDEX.md                            # Story tracking index
      [generated stories]                 # From your documents
    workflows/
      user-approval.md                    # Task resolution protocol
  context-engineering-skill/              # The skill itself (keep for updates)
    README.md
    commands/
    templates/
    docs/
```

---

## How It Works

### Context Loading Tiers

Not everything loads at once. Context is loaded progressively:

| Tier | What | When | Budget |
|------|------|------|--------|
| Always | CLAUDE.md + .claude/rules/ | Every session | ~2K tokens |
| Start | stories/INDEX.md | Session start | ~1K tokens |
| Task | Active story + relevant context | Starting specific task | ~3K tokens |
| Demand | Workflow rules, domain files | When specific need arises | ~5K tokens |
| Archive | Completed stories, session log | Historical review only | ~2K tokens |

### Story System

Work is tracked through story files:

| Prefix | Meaning |
|--------|---------|
| `ACTIVE-` | Currently in progress |
| `BLOCKED-` | Waiting on dependency |
| `DONE-` | Completed |
| `BACKLOG-` | Planned, not started |

### Memory Layers

Context is organized in 4 layers:

| Layer | Scope | Storage | Lifetime |
|-------|-------|---------|----------|
| Session | Current conversation | Context window | Until session end |
| Working | Current task | Story files | Duration of task |
| Project | Entire project | CLAUDE.md + context/ | Project lifetime |
| Identity | Cross-project | ~/.claude agent memory | Indefinite |

See [docs/memory-layers.md](docs/memory-layers.md) for the full architecture.

---

## Customization

### Adding Project-Specific Context Files

After init, add domain files to `context/` using `/context-ingest` or manually:
- `context/CONFIG.md` - Configuration schemas
- `context/API.md` - API specifications
- `context/ARCHITECTURE.md` - Architecture decisions
- `context/TROUBLESHOOTING.md` - Debug guides

### Adding Workflow Rules

- **Always-loaded rules**: `.claude/rules/[name].md` (increases token budget)
- **On-demand rules**: `context/workflows/[name].md` (loaded when needed)

### Modifying Templates

Templates in `context-engineering-skill/templates/` can be customized before running `/context-init`. Placeholders use `{{DOUBLE_BRACE}}` syntax.

---

## Uninstall

To remove context engineering from a project:

```bash
# Remove commands
rm .claude/commands/context-init.md
rm .claude/commands/context-ingest.md
rm .claude/commands/context-start.md

# Remove generated structure (CAREFUL - this deletes all context!)
rm -rf .claude/rules/
rm -rf context/
rm CLAUDE.md

# Remove the skill folder
rm -rf context-engineering-skill/
```

---

## Documentation

| Document | Description |
|----------|-------------|
| [Context Engineering Guide](docs/context-engineering-guide.md) | Full principles and philosophy |
| [Commands Reference](docs/commands-reference.md) | Detailed command documentation |
| [Rules Reference](docs/rules-reference.md) | Default and optional rules catalog |
| [Memory Layers](docs/memory-layers.md) | 4-layer memory architecture |

---

## Requirements

- **Claude Code** (any version with slash command support)
- No external dependencies (no npm, pip, or other packages)
- Works on any OS (macOS, Linux, Windows)
- Works with any programming language or framework

---

## License

MIT
