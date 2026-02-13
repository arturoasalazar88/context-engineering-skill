# Context Engineering - Start Session

Load project context properly, report readiness status, and select a story to work on.

## Usage

```
/context-start
```

## Instructions

When the user runs this command, execute these steps in order:

### Step 1: Verify Structure

Check the project root for context engineering structure:
- [ ] `CLAUDE.md` exists
- [ ] `.claude/rules/` directory exists
- [ ] `context/stories/` directory exists

If any are missing:
"Context engineering structure not found. Run `/context-init` first to set up the project."
Stop here.

### Step 2: Load Always-Loaded Context

Read these files from the project root:
1. `CLAUDE.md`
2. All `.md` files in `.claude/rules/`

Count the lines in each file for token estimation.

### Step 3: Calculate Token Budget

For each file loaded:
- Count total lines
- Estimate tokens: lines x 10 (rough approximation)

Determine the context window zone:
- **Green** (0-100K tokens): Safe - normal work
- **Yellow** (100K-140K tokens): Caution - monitor usage, avoid large tasks
- **Red** (140K-160K tokens): High - recommend ending session soon
- **Critical** (160K+ tokens): End session immediately

### Step 4: Report Context Status

Display this report:

```
=== Session Context Status ===

Always-loaded context:
  CLAUDE.md:                     XX lines (~X,XXX tokens)
  core-rules.md:                 XX lines (~XXX tokens)
  context-enforcement.md:        XX lines (~XXX tokens)
  context-window-monitoring.md:  XX lines (~XXX tokens)
  [any additional .claude/rules/*.md files]
  ------------------------------------------------
  Total static context:          XX lines (~X,XXX tokens)

Budget compliance:
  Target: <250 lines (<2,500 tokens)
  Status: [Within budget / Over budget by XX lines]
```

### Step 5: Load Stories Index

Read `context/stories/INDEX.md` from the project root.

Extract:
- Active stories (ACTIVE-* entries)
- Blocked stories (BLOCKED-* entries)
- Backlog stories (BACKLOG-* entries)
- Active bugs (if any)

### Step 6: Display Stories and Offer Selection

```
Active Stories:
| # | ID  | Title                    | Status  |
|---|-----|--------------------------|---------|
| 1 | XXX | [title from INDEX.md]    | ACTIVE  |
| 2 | XXX | [title]                  | ACTIVE  |
[... list all active stories]

Blocked:
| # | ID  | Title                    | Blocked By |
|---|-----|--------------------------|------------|
[... if any]

Backlog:
| # | ID  | Title                    | Priority |
|---|-----|--------------------------|----------|
| N | XXX | [title]                  | High     |
[... list backlog items]

Which story would you like to work on?
(Enter a number, or 'skip' to work without a story)
```

### Step 7: Load Selected Story

**If user selects a story:**
1. Read the story file from `context/stories/`
2. Display the story objective
3. Show the task checklist with current status
4. Highlight the next uncompleted task
5. Show any blockers

**If user types 'skip':**
"No story loaded. Ready to work on ad-hoc tasks. Use `/context-ingest` to add new work items."

### Step 8: Ready Report

```
Session started!

Context loaded: ~X,XXX tokens
Working on: Story XXX - [Title] (or: No story selected)
Zone: Green (safe for normal work)
Remaining capacity: ~XXX,XXX tokens

Ready to begin. I'll monitor context window usage and
warn you before approaching limits.
```

## Notes

- This command replaces manual session-start procedures
- Always reads from project root, never hardcoded paths
- Token estimates use lines x 10 approximation (rough but useful)
- Zone thresholds follow context-window-monitoring.md rules
- If no stories exist yet, suggest using /context-ingest to create the first one
