# {{PROJECT_NAME}} - Agent Context

<metadata>
  <project>{{PROJECT_SLUG}}</project>
  <components>{{COMPONENTS_LIST}}</components>
  <last_updated>{{DATE}}</last_updated>
</metadata>

> **START HERE**: Load [context/stories/INDEX.md](context/stories/INDEX.md) for active tasks.

---

## Components

| Component | Purpose | Location |
|-----------|---------|----------|
{{COMPONENTS_TABLE}}

---

## Servers

| Server | IP | User | Path |
|--------|-----|------|------|
{{SERVERS_TABLE}}

> **Credentials:** See `context/SYSTEM.md` (load on demand)

---

## Context Files (Load as Needed)

| File | Purpose | Load When |
|------|---------|-----------|
| **context/stories/INDEX.md** | **Active tasks & progress** | **ALWAYS first** |
| context/SYSTEM.md | Server info & credentials | SSH, checking status |
| context/MEMORY-PROTOCOL.md | Memory management guide | Managing memory layers |
| context/workflows/*.md | Detailed workflow rules | Per workflow need |
| context/stories/SESSION-LOG.md | Historical sessions | Reviewing past work |
{{ADDITIONAL_CONTEXT_FILES}}

---

## Status ({{DATE}})

| Service | Status | Version |
|---------|--------|---------|
{{STATUS_TABLE}}

---

## Context Loading Tiers

| Tier | What | When | Budget |
|------|------|------|--------|
| Always | CLAUDE.md, core-rules.md | Every session | ~2K tokens |
| Start | stories/INDEX.md | Session start | ~1K tokens |
| Task | Active story + relevant context | Starting specific task | ~3K tokens |
| Demand | Workflow rules, troubleshooting, etc. | When specific need arises | ~5K tokens |
| Archive | DONE-* stories, session log | Only for historical review | ~2K tokens |

> **Schema:** `context/CONTEXT-SCHEMA.yaml`

---

## Core Rules

1. **NEVER mark tasks resolved without explicit user approval**
2. **ALWAYS present summary + evidence before requesting resolution**
3. **ALWAYS load stories/INDEX.md at session start**
4. **NEVER store secrets/passwords in CLAUDE.md or context files** (use SYSTEM.md)
5. **ALWAYS update story files at task milestones**
6. **ALWAYS follow context engineering principles** (see `.claude/rules/context-enforcement.md`)
7. **MONITOR context window usage** - Report at key points, end session before compaction
{{OPTIONAL_RULES}}

> **Detailed rules:** `.claude/rules/core-rules.md` (auto-loaded) -> `context/workflows/` (load on demand)

---

## How to Use This Context System

**At Session Start:**
1. You automatically load: CLAUDE.md + .claude/rules/*.md (~2K tokens)
2. ALWAYS read context/stories/INDEX.md next
3. Load active story file for task being worked on

**During Work:**
- Load workflow rules from context/workflows/ ONLY when needed
- Load domain files (SYSTEM.md, CONFIG.md) only when task requires them
- Check Context Loading Tiers table if unsure what to load

**Monitor Context Window:**
- Report usage at session start
- Check after completing stories/tasks
- Watch for Yellow zone (100K+) and Red zone (140K+) warnings
- End session proactively before 160K token limit

**At Session End:**
- Report final token usage
- Update story file with progress
- Add key learnings to CLAUDE.md if significant
- Prune verbose tool outputs from conversation (keep conclusions)

---

## Key Learnings

{{KEY_LEARNINGS}}

---

## Current Priorities

See [context/stories/INDEX.md](context/stories/INDEX.md) for active priorities and backlog.

---

## Quick Reference

```bash
# Start session
/context-start

# Add new context
/context-ingest
{{CUSTOM_COMMANDS}}
```
