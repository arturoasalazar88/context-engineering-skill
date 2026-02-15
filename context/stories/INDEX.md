# Stories Index

<metadata>
  <purpose>Track project tasks, progress, and decisions</purpose>
  <format>One file per story, prefixed with status</format>
</metadata>

---

## Story Status Legend

| Status | Prefix | Description |
|--------|--------|-------------|
| ACTIVE | `ACTIVE-` | Currently in progress |
| BLOCKED | `BLOCKED-` | Waiting on dependency |
| DONE | `DONE-` | Completed |
| BACKLOG | `BACKLOG-` | Planned, not started |

---

## Active Stories

| ID | Title | Status | Updated | File |
|----|-------|--------|---------|------|
| BUG-001 | Validate Workflow Tracking Fix | ACTIVE | 2026-02-14 | [ACTIVE-BUG001-validate-fix.md](ACTIVE-BUG001-validate-fix.md) |

> **LOAD ACTIVE STORY**: Read the active story file for detailed tasks and next actions.

---

## Last Session: 2026-02-14

**Completed:**
- Context engineering initialization

> **Full session history:** See [SESSION-LOG.md](SESSION-LOG.md)

---

## Active Bugs

| ID | Title | Severity | Updated | File |
|----|-------|----------|---------|------|
| BUG-001 | Workflow Tracking in /context-start | HIGH | 2026-02-14 | [docs/bugs/BUG-001-workflow-tracking.md](../../docs/bugs/BUG-001-workflow-tracking.md) |

---

## Backlog

| ID | Title | Priority |
|----|-------|----------|
| 001 | Test BUG-001 fix with triptaste/landing-page | High |
| 002 | Document /context-update process | High |
| 003 | Merge bugfix branch to main | High |
| 004 | Create v1.1.0 release | Medium |
| 005 | Fix README command count inconsistency | Low |

---

## Completed

| ID | Title | Completed |
|----|-------|-----------|

---

## Story Template

When creating a new story, use this template:

```markdown
# Story [ID]: [Title]

<metadata>
  <id>XXX</id>
  <status>ACTIVE|BLOCKED|DONE|BACKLOG</status>
  <created>YYYY-MM-DD</created>
  <updated>YYYY-MM-DD</updated>
  <blocked_by>optional</blocked_by>
</metadata>

## Objective
[What we're trying to accomplish]

## Tasks
- [ ] Task 1
- [ ] Task 2

## Progress Log
| Date | Update |
|------|--------|

## Decisions Made
[Key decisions and rationale]

## Blockers
[Current blockers if any]

## Context Engineering Compliance

- [ ] Story file uses structured format (checklists, tables, YAML)
- [ ] No credentials in story file
- [ ] Acceptance criteria are clear and measurable
- [ ] Memory layer identified (Session/Working/Project/Identity)
- [ ] New files follow CONTEXT-SCHEMA.yaml placement rules
- [ ] Token budget impact assessed for new context

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Outcome
[Final result when completed]
```
