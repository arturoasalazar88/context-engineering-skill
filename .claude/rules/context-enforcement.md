# Context Engineering Enforcement Rules

> Ensure all sessions follow context engineering principles

---

## Session Start

- [ ] Verify CLAUDE.md is under 150 lines
- [ ] Verify `.claude/rules/` contains only essential rule files
- [ ] Load `context/stories/INDEX.md` after reading CLAUDE.md

---

## Before Creating New Files

- [ ] Check `CONTEXT-SCHEMA.yaml` for proper location
- [ ] Ensure structured format (tables, key-value, checklists - NOT prose)
- [ ] Verify no credentials in content
- [ ] Confirm file doesn't belong in always-loaded context

**File Placement Quick Reference:**
- Always-loaded: Only CLAUDE.md + .claude/rules/*.md
- Context files: `context/` (domain knowledge, on-demand)
- Workflow rules: `context/workflows/` (never auto-loaded)
- Stories: `context/stories/` with prefix (ACTIVE/BLOCKED/DONE/BACKLOG)

---

## Before Adding Context

- [ ] Is this needed for current task? (If not, don't load)
- [ ] Can this be referenced instead of loaded?
- [ ] Does this fit token budget for current tier?

**Tiered Loading:**
- Always: ~2K tokens (CLAUDE.md + rules)
- Per-task: ~3K tokens (active story + relevant context)
- On-demand: ~5K tokens (workflow rules when triggered)

---

## Before Creating Stories

- [ ] Follow template in `context/stories/INDEX.md`
- [ ] Use structured format (checklists, tables, YAML)
- [ ] Specify clear acceptance criteria
- [ ] Identify which memory layer is affected (Session/Working/Project/Identity)
- [ ] Include "Context Engineering Compliance" section

---

## Session End

- [ ] Review created files for credential leaks
- [ ] Verify static context unchanged (CLAUDE.md, core-rules.md)
- [ ] Update story files with progress
- [ ] Prune verbose tool outputs from conversation

---

## Periodic Checks (Monthly)

- [ ] CLAUDE.md still under 150 lines?
- [ ] Token budget compliance? (static context < 2,500 tokens)
- [ ] Credentials only in `context/SYSTEM.md`?
- [ ] Workflow rules still on-demand (not auto-loaded)?

---

## Security: NEVER Store Credentials In

- CLAUDE.md
- context/stories/INDEX.md
- Story files (ACTIVE-*.md, DONE-*.md, etc.)
- .claude/rules/*.md

ONLY in `context/SYSTEM.md` (load on-demand)
