# Commands Reference

Detailed documentation for all three context engineering slash commands.

---

## /context-init

### Purpose

Bootstrap a new project with the complete context engineering structure, or complete a partial setup on an existing project.

### When to Use

- Setting up a brand new project
- Adding context engineering to an existing project
- Reinitializing after significant structural changes

### Full Flow

```
User runs: /context-init
                |
                v
    [1] Detect project state
        - All exists -> Offer reinitialize/cancel
        - Partial   -> Complete missing pieces
        - None      -> Full setup
                |
                v
    [2] Gather project information (interactive)
        Q1: Project name, purpose, languages
        Q2: Single vs multi-component
        Q3: Servers/infrastructure
        Q4: Technical documents
        Q5: Context onboarding (free-form)
        Q6: Optional workflow rules
                |
                v
    [3] Process documents (if provided)
        - Extract architecture, tasks, server info
        - Convert prose to structured format
        - Identify gaps, ask user
                |
                v
    [4] Create project structure
        - Read templates from context-engineering-skill/templates/
        - Replace {{PLACEHOLDERS}} with gathered info
        - Create all files at project root
                |
                v
    [5] Generate initial stories (if docs processed)
        - Create BACKLOG-XXX.md for each task
        - Add entries to INDEX.md
                |
                v
    [6] Report results
        - Files created, token budget, next steps
```

### Files Created

| File | Purpose | Always Created |
|------|---------|---------------|
| `CLAUDE.md` | Project entry point | Yes |
| `.claude/rules/core-rules.md` | Mandatory agent rules | Yes |
| `.claude/rules/context-enforcement.md` | Session checklists | Yes |
| `.claude/rules/context-window-monitoring.md` | Token monitoring | Yes |
| `context/stories/INDEX.md` | Story tracking | Yes |
| `context/CONTEXT-SCHEMA.yaml` | Loading schema | Yes |
| `context/MEMORY-PROTOCOL.md` | Memory guide | Yes |
| `context/SYSTEM.md` | Server info | Yes |
| `context/workflows/user-approval.md` | Approval protocol | Yes |
| `context/stories/BACKLOG-*.md` | Initial stories | If docs provided |

### Example Session

```
User: /context-init

Agent: Let me set up context engineering for this project.

First, some basics:
- Project name: What should I call this project?
- Purpose: What does this project do?
- Primary language(s)?

User: "TaskFlow" - A task management API. TypeScript + PostgreSQL.

Agent: Does this project have multiple components?
A) Single component
B) Multiple components

User: Multiple - API at ./api, Frontend at ./web, Worker at ./worker

Agent: Do you have servers to document?

User: Yes - production at api.taskflow.io, staging at staging.taskflow.io

[... continues through all questions ...]

Agent: Context engineering initialized!

Structure created:
- CLAUDE.md (87 lines)
- .claude/rules/ (3 files)
- context/ (schema, memory protocol, system info)
- context/stories/ (index + 3 initial stories)

Token budget: ~2,100 tokens (within <2,500 target)

Next steps:
1. Review CLAUDE.md
2. Add credentials to context/SYSTEM.md
3. Start working: /context-start
```

---

## /context-ingest

### Purpose

Add new context to the project with automatic categorization and placement.

### When to Use

- Adding a new task or feature request
- Documenting architecture decisions
- Adding workflow rules or processes
- Recording server/deployment information
- Any time you have new information to integrate

### Content Types and Placement

| Content Type | Destination | Example |
|-------------|-------------|---------|
| Story/Task | `context/stories/BACKLOG-XXX.md` | "Add user authentication" |
| Technical Doc | `context/[DOMAIN].md` | Architecture doc, API spec |
| Workflow Rule (always) | `.claude/rules/[name].md` | "Always run tests before commit" |
| Workflow Rule (specific) | `context/workflows/[name].md` | "Deployment checklist" |
| System Info | `context/SYSTEM.md` | Server details, credentials |
| Project Context | `CLAUDE.md` sections | New component, key learning |

### Placement Decision Tree

```
Content Analysis:

Is it a task/feature/bug?
  YES -> STORY
  |   Single task?    -> context/stories/BACKLOG-XXX.md
  |   Multiple tasks? -> Break into separate stories
  NO
  |
Is it a rule/process?
  YES -> RULE
  |   Every session?  -> .claude/rules/ (WARNING: budget impact!)
  |   Specific flow?  -> context/workflows/
  NO
  |
Is it technical reference?
  YES -> CONTEXT
  |   Architecture -> context/ARCHITECTURE.md
  |   API specs    -> context/API.md
  |   Database     -> context/DATABASE.md
  |   Config       -> context/CONFIG.md
  |   Conventions  -> context/CONVENTIONS.md
  |   Other        -> context/[DOMAIN].md
  NO
  |
Is it server/credentials?
  YES -> context/SYSTEM.md (ALWAYS here, nowhere else)
  NO
  |
Is it general project info?
  YES -> Update CLAUDE.md (Components, Status, Key Learnings)
```

### Example Session

```
User: /context-ingest

Agent: What type of context are you adding?
A) Story/Task
B) Technical Document
C) Workflow Rule
D) System Information
E) Project Context
F) Auto-detect

User: A - Story. We need to add rate limiting to the API.

Agent: I will place this content as follows:

Type: Story
File: context/stories/BACKLOG-004-api-rate-limiting.md
Action: Create new file

Preview:
---
# Story 004: Add API Rate Limiting
<metadata>
  <id>004</id>
  <status>BACKLOG</status>
  ...
</metadata>

## Objective
Add rate limiting to the API...

## Tasks
- [ ] Research rate limiting strategies
- [ ] Implement rate limiter middleware
- [ ] Add configuration options
- [ ] Write tests
---

Token impact: +450 tokens (on-demand, loaded per-task)
Budget status: Within budget

Proceed? [Yes/No/Edit]

User: Yes

Agent: Context ingested!
Type: Story
Location: context/stories/BACKLOG-004-api-rate-limiting.md
Story added to INDEX.md
```

---

## /context-start

### Purpose

Automate the beginning of every work session with proper context loading and status reporting.

### When to Use

- Beginning of every work session
- After returning from a break
- When switching between projects

### Full Flow

```
User runs: /context-start
                |
                v
    [1] Verify structure exists
        - CLAUDE.md, .claude/rules/, context/stories/
        - If missing -> "Run /context-init first"
                |
                v
    [2] Load always-loaded context
        - CLAUDE.md
        - All .claude/rules/*.md files
                |
                v
    [3] Calculate token budget
        - Count lines in each file
        - Estimate tokens (lines x 10)
        - Determine zone (Green/Yellow/Red/Critical)
                |
                v
    [4] Report context status
        - File-by-file breakdown
        - Total static context
        - Budget compliance check
                |
                v
    [5] Load stories index
        - Read context/stories/INDEX.md
        - Extract active, blocked, backlog stories
                |
                v
    [6] Offer story selection
        - Display stories in numbered list
        - User picks one or skips
                |
                v
    [7] Load selected story
        - Read story file
        - Show objective, tasks, next step
                |
                v
    [8] Ready report
        - Tokens loaded, story selected, zone status
```

### Zone System

| Zone | Token Range | Status Bar | Recommended Action |
|------|------------|------------|-------------------|
| Green | 0-100K | Safe | Normal work, take on any task |
| Yellow | 100K-140K | Caution | Monitor usage, avoid starting large new tasks |
| Red | 140K-160K | High | Finish current task, end session soon |
| Critical | 160K+ | Critical | End session immediately, save progress |

### Example Session

```
User: /context-start

Agent:
=== Session Context Status ===

Always-loaded context:
  CLAUDE.md:                     87 lines (~870 tokens)
  core-rules.md:                 27 lines (~270 tokens)
  context-enforcement.md:        82 lines (~820 tokens)
  context-window-monitoring.md:  37 lines (~370 tokens)
  ------------------------------------------------
  Total static context:          233 lines (~2,330 tokens)

Budget compliance:
  Target: <250 lines (<2,500 tokens)
  Status: Within budget

Active Stories:
| # | ID  | Title                    | Status  |
|---|-----|--------------------------|---------|
| 1 | 001 | Setup CI/CD pipeline     | ACTIVE  |
| 2 | 003 | Add user authentication  | ACTIVE  |

Backlog:
| # | ID  | Title                    | Priority |
|---|-----|--------------------------|----------|
| 3 | 004 | Add API rate limiting    | High     |
| 4 | 005 | Setup monitoring         | Medium   |

Which story would you like to work on? (1-4, or 'skip')

User: 1

Agent:
[Reads Story 001]

Story 001: Setup CI/CD Pipeline
Objective: Configure GitHub Actions for automated testing and deployment

Tasks:
- [x] Create .github/workflows directory
- [x] Add test workflow
- [ ] Add deployment workflow    <-- NEXT
- [ ] Configure staging environment

Session started!
Context loaded: ~3,330 tokens
Working on: Story 001 - Setup CI/CD Pipeline
Zone: Green (safe for normal work)
Remaining capacity: ~196,000 tokens

Ready to begin.
```

---

## Command Dependencies

```
/context-init  (run first, creates structure)
      |
      v
/context-start  (run at session start, loads context)
      |
      v
/context-ingest  (run anytime, adds new content)
```

- `/context-start` and `/context-ingest` require the structure from `/context-init`
- `/context-init` only needs to run once per project
- `/context-start` should run at the beginning of every session
- `/context-ingest` can be used anytime during a session
