# Story 001: Test BUG-001 Fix

<metadata>
  <id>001</id>
  <status>BACKLOG</status>
  <created>2026-02-14</created>
  <updated>2026-02-14</updated>
</metadata>

---

## Objective

Verify that BUG-001 fix works correctly in a real project (triptaste/landing-page) by testing the workflow scanning functionality.

## Tasks

- [ ] Navigate to triptaste/landing-page project
- [ ] Run `/context-start` command
- [ ] Verify mandatory workflows section appears
- [ ] Verify workflows with 🔒 markers are auto-loaded
- [ ] Verify token budget includes mandatory workflow tokens
- [ ] Verify agent follows mandatory workflow rules
- [ ] Document any issues found
- [ ] If issues found, create bug report

## Progress Log

| Date | Update |
|------|--------|
| 2026-02-14 | Story created from BUG-001 incomplete tasks |

## Decisions Made

None yet.

## Blockers

None.

## Context Engineering Compliance

- [x] Story file uses structured format (checklists, tables, YAML)
- [x] No credentials in story file
- [x] Acceptance criteria are clear and measurable
- [x] Memory layer identified (Working Memory - Layer 2)
- [x] New files follow CONTEXT-SCHEMA.yaml placement rules
- [x] Token budget impact assessed (~1,500 tokens per-task)

## Acceptance Criteria

- [ ] `/context-start` successfully scans context/workflows/
- [ ] Mandatory workflows (with 🔒 markers) are auto-loaded
- [ ] Non-mandatory workflows are listed as "available on-demand"
- [ ] Token budget calculation includes mandatory workflows
- [ ] Agent respects mandatory workflow rules during work
- [ ] No errors or unexpected behavior

## Outcome

[To be filled when completed]
