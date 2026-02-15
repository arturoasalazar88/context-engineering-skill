# Story BUG-001: Validate Workflow Tracking Fix

<metadata>
  <id>BUG-001</id>
  <status>ACTIVE</status>
  <created>2026-02-14</created>
  <updated>2026-02-14</updated>
  <related_bug>docs/bugs/BUG-001-workflow-tracking.md</related_bug>
</metadata>

## Objective

Validate that BUG-001 fix (workflow tracking in /context-start) is fully implemented and functional in the context-engineering-skill repository, then prepare for testing in triptaste/landing-page.

## Context

BUG-001 was discovered when the agent violated mandatory workflow rules in triptaste/landing-page because `/context-start` did not scan or report on `context/workflows/` files. The fix adds workflow scanning with auto-loading of mandatory workflows (marked with 🔒 MANDATORY or 🔒 INVIOLABLE).

## Tasks

**Phase 1: Validate Implementation in This Repo**
- [x] Verify `/context-start` command includes Step 3 (Scan Workflows)
- [x] Verify `core-rules.md` includes rule #8 (check workflows at session start)
- [x] Verify `CONTEXT-SCHEMA.yaml` includes mandatory_workflows tier
- [x] Verify `CONTEXT-SCHEMA.yaml` includes mandatory_workflows in total_context_budget
- [ ] Test `/context-start` execution in this repo (verify workflow detection works)
- [ ] Verify workflow classification (mandatory vs available) works correctly

**Phase 2: Prepare External Testing**
- [ ] Test with triptaste/landing-page project
- [ ] Verify mandatory workflows (hybrid-workflow.md, gemini-cli.md) are auto-loaded
- [ ] Verify agent follows mandatory workflow rules during session
- [ ] Document /context-update process (how to apply fix to existing projects)

**Phase 3: Release Preparation**
- [ ] Update README if needed
- [ ] Create release notes for v1.1.0
- [ ] Merge bugfix/BUG-001-workflow-tracking to main
- [ ] Tag v1.1.0 release

## Progress Log

| Date | Update |
|------|--------|
| 2026-02-14 | Story created. Implementation verified in repo. |

## Decisions Made

1. **Hybrid approach selected**: Auto-load mandatory workflows, list others as available
2. **Detection method**: Scan first 20 lines for 🔒 MANDATORY or 🔒 INVIOLABLE markers
3. **Token budget**: 3,000 tokens for mandatory workflows tier

## Blockers

None currently.

## Context Engineering Compliance

- [x] Story file uses structured format (checklists, tables, YAML)
- [x] No credentials in story file
- [x] Acceptance criteria are clear and measurable
- [x] Memory layer identified: Project (affects how context-start works)
- [x] New files follow CONTEXT-SCHEMA.yaml placement rules
- [x] Token budget impact assessed (adds ~200 tokens for tracking)

## Acceptance Criteria

- [ ] `/context-start` successfully detects and reports workflows in this repo
- [ ] Mandatory workflows are auto-loaded with 🔒 marker in report
- [ ] Available workflows are listed without auto-loading
- [ ] Token budget calculations include mandatory workflow tokens
- [ ] Agent follows mandatory workflow rules when they exist
- [ ] Documentation exists for applying fix via /context-update

## Outcome

To be determined after validation testing.
