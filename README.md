# Context Engineering Skill for Claude Code

A set of Claude Code slash commands that implement context engineering best practices for any project. Initialize projects with optimal context structure, ingest new context intelligently, and manage sessions with proper context loading.

---

## Table of Contents

- [What Is This?](#what-is-this)
- [Quick Start](#quick-start)
- [Installation](#installation)
  - [Automated Installation](#automated-installation-recommended)
  - [Manual Installation](#manual-installation)
  - [Upgrading Existing Installation](#upgrading-existing-installation)
- [Commands](#commands)
  - [/context-init](#context-init---project-initialization)
  - [/context-ingest](#context-ingest---smart-context-ingestion)
  - [/context-start](#context-start---session-management)
  - [/context-refactor](#context-refactor---implementation-audit--refactor)
  - [/context-update](#context-update---apply-bug-fixes--updates)
  - [/context-close](#context-close---session-cleanup--metrics)
- [What Gets Created](#what-gets-created)
- [How It Works](#how-it-works)
- [Customization](#customization)
- [Uninstall](#uninstall)
- [Documentation](#documentation)
- [Requirements](#requirements)
- [License](#license)

---

## What Is This?

Six Claude Code slash commands that automate context engineering:

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/context-init` | Initialize project with context engineering | Once, at project setup |
| `/context-ingest` | Add new context intelligently | Anytime you have new info to add |
| `/context-start` | Start session with proper context loading | Beginning of every session |
| `/context-close` | Close session with compliance checks & metrics | End of every session |
| `/context-refactor` | Audit and refactor existing implementation | When upgrading or fixing issues |
| `/context-update` | Apply bug fixes and feature updates | When updates are available |

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

# 3a. NEW project? Initialize from scratch:
/context-init

# 3b. EXISTING context engineering? Audit & upgrade:
/context-refactor

# 4. Every session, start with:
/context-start

# 5. End every session with:
/context-close
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

**Step 3a: NEW project - Initialize**

Open your project in Claude Code and run:
```
/context-init
```
Interactive wizard creates complete structure from scratch.

**Step 3b: EXISTING context engineering - Audit & upgrade**

If you already have CLAUDE.md and context files:
```
/context-refactor
```
Audits your implementation and fixes issues.

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

**Automated Update (Recommended):**

```bash
# 1. In your project, run:
/context-update --check

# 2. Review what will be updated:
/context-update --diff

# 3. Apply updates with automatic backup:
/context-update --apply
```

The `/context-update` command:
- Fetches latest fixes from GitHub (no cloning needed)
- Checks what fixes are already applied
- Creates automatic backup before changes
- Updates commands and applies bug fixes
- Tracks applied fixes in `context/APPLIED-FIXES.yaml`

**Manual Update:**

If you need to manually update commands:

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

Audits an **existing** context engineering implementation and refactors it to match current best practices and templates.

> **When to use:** For projects that ALREADY have context engineering (CLAUDE.md, .claude/rules/, etc.). For NEW projects, use `/context-init` instead.

**Usage:**
```
/context-refactor              # Interactive mode (default)
/context-refactor --report-only   # Generate audit report only
/context-refactor --auto          # Auto-apply safe fixes
```

#### What It Audits

**1. Security (CRITICAL Priority)**
- API keys, passwords, tokens in CLAUDE.md, rules, or stories
- SSH private keys
- Exposed credentials anywhere except context/SYSTEM.md
- Pattern matching: `api[_-]?key`, `sk-*`, `password`, `token`, `BEGIN.*PRIVATE KEY`

**2. Structure (HIGH Priority)**
- Required files: CLAUDE.md, 3 rule files, INDEX.md
- CLAUDE.md line count (target: <150 lines, max: <200 lines)
- File naming conventions: STATUS-XXX-slug.md for stories
- Directory structure matches schema

**3. Token Budget (HIGH Priority)**
- Always-loaded context calculation (lines × 10)
- Target: <2,500 tokens total
- Maximum: <3,000 tokens total
- Breakdown by file (CLAUDE.md + all .claude/rules/*.md)

**4. Format (MEDIUM Priority)**
- CLAUDE.md structure matches template
- Metadata blocks present in stories
- Tables vs prose (structured data preferred)
- INDEX.md follows standard sections

**5. Story System (MEDIUM Priority)**
- Story file naming: ACTIVE-, DONE-, BLOCKED-, BACKLOG- prefixes
- Metadata blocks in each story
- INDEX.md lists all stories properly

**6. Content (LOW Priority)**
- Prose paragraphs that could be tables
- Optimization opportunities

#### Modes Explained

| Mode | When to Use | Behavior |
|------|-------------|----------|
| **Interactive** (default) | Most common case | Reviews each fix, asks for approval before applying |
| `--report-only` | Initial assessment, high token sessions | Generates report, makes NO changes |
| `--auto` | Trusted setup, minor fixes | Auto-applies safe fixes, skips risky ones |

#### What It Fixes

**Safe Fixes (auto-fixable):**
- Missing rule files (created from templates)
- Missing CONTEXT-SCHEMA.yaml or MEMORY-PROTOCOL.md
- Wrong story naming (auto-renames to STATUS-XXX-slug.md)
- Missing metadata blocks (added to story files)
- Missing INDEX.md (created from template)

**Interactive Fixes (needs approval):**
- Credentials found (shows location, offers to move to SYSTEM.md)
- CLAUDE.md over 200 lines (suggests content to split out)
- Prose paragraphs (shows table conversion preview)
- Token budget over target (suggests files to move out)

**Manual Fixes (guidance only):**
- Exposed API keys (provides step-by-step remediation)
- Significant structural mismatches (suggests /context-init)
- Complex content issues (provides specific suggestions)

#### Safety Features

**Mandatory Backups:**
- Always creates `.backup/context-refactor-[timestamp]/` before ANY modifications
- Copies all files that will be modified
- Adds `.backup/` to .gitignore automatically
- You can restore from backup if needed

**Conservative Approach:**
- NEVER auto-moves credentials (security sensitive)
- NEVER modifies files without approval (unless --auto mode)
- NEVER logs or displays actual credential values
- Respects intentional deviations from standards

**Verification:**
- Re-runs audit checks after applying fixes
- Confirms issues are resolved
- Reports before/after metrics

#### Example Output

```
=== Context Engineering Audit Report ===

Project: ai-local-chatbot
Audit Date: 2026-02-13
Overall Status: NEEDS ATTENTION

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CRITICAL Issues (1):
  ⚠️  API key found in CLAUDE.md
      File: CLAUDE.md:42
      Fix: Move to context/SYSTEM.md

HIGH Priority Issues (2):
  ▲ CLAUDE.md exceeds target
     Current: 185 lines (~1,850 tokens)
     Expected: <150 lines
     Fix: Move Key Learnings to context/PROJECT-HISTORY.md

  ▲ Token budget over target
     Current: 2,850 tokens
     Target: <2,500 tokens

MEDIUM Priority Issues (1):
  ● Story naming doesn't match convention
     Suggestion: Rename story-001.md → BACKLOG-001-story.md

Token Budget Analysis:
  CLAUDE.md:                    185 lines (~1,850 tokens)
  core-rules.md:                 28 lines (~280 tokens)
  context-enforcement.md:        83 lines (~830 tokens)
  ────────────────────────────────────────
  Total:                        296 lines (~2,960 tokens)
  Status:                       ⚠ Over target by 460 tokens

How would you like to proceed?
A) Auto-fix safe issues (structure, missing files, renames)
B) Interactive fix (review each issue before applying)
C) Cancel (just show me the report)
```

#### Use Cases

| Scenario | How to Use |
|----------|------------|
| Upgrading old context engineering | Run `/context-refactor` to align with latest standards |
| Periodic compliance audit | Run `/context-refactor --report-only` monthly |
| After major changes | Verify structure still compliant |
| Team adoption prep | Audit and fix all issues before sharing |
| Token budget cleanup | Find and fix budget violations |

#### When NOT to Use

- **New project with no context engineering**: Use `/context-init` instead
- **Completely custom structure**: This tool enforces standards; customize at your own risk
- **Just learning the system**: Start with `/context-init` to see proper structure first

See [docs/commands-reference.md](docs/commands-reference.md) for detailed audit checks, all patterns used, and more examples.

---

## Fix Tracking System

Context engineering uses a centralized fix tracking system to manage bug fixes and updates.

### How It Works

**1. Central Fixes Manifest (`FIXES-MANIFEST.yaml`)**
- Located in the skill repository
- Lists all available bug fixes with metadata
- Fetched via GitHub raw URLs (no cloning needed)
- Single source of truth for what's available

**2. Project Applied Fixes (`context/APPLIED-FIXES.yaml`)**
- Created in each project using context engineering
- Tracks which fixes have been applied
- Prevents duplicate application
- Maintains update history

**3. Update Workflow**
```bash
# Check for available updates
/context-update --check

# See detailed changes
/context-update --diff

# Apply updates with automatic backup
/context-update --apply
```

**Benefits:**
- No need to manually track what's been applied
- Automatic detection of already-applied fixes
- Safe updates with backup creation
- Works without cloning (uses GitHub raw URLs)
- Version-aware: knows what version each fix targets

### Available Fixes

Current fixes tracked in `FIXES-MANIFEST.yaml`:

| ID | Title | Severity | Version | Status |
|----|-------|----------|---------|--------|
| BUG-001 | Workflow Tracking in /context-start | HIGH | 1.1.0 | FIXED |
| FEATURE-001 | Add /context-close command | - | 1.2.0 | FIXED |

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
      context-close.md                    # /context-close command
      context-refactor.md                 # /context-refactor command
      context-update.md                   # /context-update command
    rules/
      core-rules.md                       # 8 mandatory agent rules
      context-enforcement.md              # Session checklists
      context-window-monitoring.md        # Token usage monitoring
  context/
    CONTEXT-SCHEMA.yaml                   # What loads when (token budgets)
    MEMORY-PROTOCOL.md                    # Memory management guide
    SYSTEM.md                             # Server info & credentials
    APPLIED-FIXES.yaml                    # Tracks applied bug fixes
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
