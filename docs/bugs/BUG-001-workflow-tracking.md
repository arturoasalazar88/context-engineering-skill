# BUG-001: Context Engineering Workflow Tracking

<metadata>
  <id>BUG-001</id>
  <status>FIXED</status>
  <severity>HIGH</severity>
  <created>2026-02-14</created>
  <updated>2026-02-14</updated>
  <fixed_in>1.1.0</fixed_in>
  <type>context-engineering-skill-bug</type>
  <affects>context-start, core-rules, CONTEXT-SCHEMA</affects>
</metadata>

---

## Problem Statement

The `/context-start` skill does NOT properly track or report on workflow files in `context/workflows/`. This causes agents to:
1. Be unaware of mandatory workflow rules
2. Violate inviolable rules (like hybrid workflow, gemini-cli)
3. Miss critical context that should inform their behavior

---

## Root Cause

The `/context-start` skill implementation:
1. Only scans `.claude/rules/` for always-loaded rules
2. Only scans `context/stories/` for task tracking
3. **Missing:** Does not scan or report on `context/workflows/`
4. **Missing:** No mechanism to identify mandatory workflows (🔒 MANDATORY / 🔒 INVIOLABLE markers)

---

## Fix Summary

**Solution applied:** Hybrid Approach — auto-load mandatory workflows, list others as available.

| What Changed | Description |
|---|---|
| `/context-start` | Added Step 3 (Scan Workflows) to detect and auto-load mandatory workflows |
| `core-rules.template.md` | Added rule #8: check workflows at session start |
| `CONTEXT-SCHEMA.template.yaml` | Added `mandatory_workflows` tier with 3,000 token budget |
| `/context-update` | New command to apply fixes to existing projects |

---

## Fix Manifest

> This section is read by `/context-update` to determine what files need updating
> in existing project implementations.

### Files to Replace (always safe)

These files contain no project-specific content and can be safely replaced:

| Source (in skill repo) | Target (in project) |
|---|---|
| `commands/context-start.md` | `.claude/commands/context-start.md` |
| `commands/context-update.md` | `.claude/commands/context-update.md` |

### Files to Merge (preserve project customizations)

These files may contain project-specific additions. Apply the specific changes below
while preserving any custom content.

#### `.claude/rules/core-rules.md`

**Source template:** `templates/core-rules.template.md`

**Change:** Add rule #8 after rule #7 if not already present.

```markdown
8. **ALWAYS check context/workflows/ for mandatory workflows at session start** (🔒 MANDATORY / 🔒 INVIOLABLE markers)
```

**Detection:** Check if the file already contains "check context/workflows/" — if yes, skip.

#### `context/CONTEXT-SCHEMA.yaml`

**Source template:** `templates/CONTEXT-SCHEMA.template.yaml`

**Change 1:** Add `mandatory_workflows` tier after the `always` tier if not already present.

```yaml
  mandatory_workflows:
    description: "Workflows with 🔒 MANDATORY/INVIOLABLE markers, auto-loaded at session start"
    detection: "Scan first 20 lines of each context/workflows/*.md for 🔒 MANDATORY or 🔒 INVIOLABLE"
    files: []  # populated per-project based on marker detection
    total_budget: 3000
```

**Detection:** Check if file already contains "mandatory_workflows" — if yes, skip.

**Change 2:** Update `total_context_budget` section to include mandatory workflows.

```yaml
total_context_budget:
  always_loaded: 2000
  mandatory_workflows: 3000  # auto-loaded workflows with 🔒 markers
  typical_session: 9000   # always + mandatory_workflows + start + per_task
  maximum_allowed: 16000  # always + mandatory_workflows + start + per_task + on_demand
  reserve_buffer: 2000    # for unexpected complexity
```

**Detection:** Check if `mandatory_workflows` key exists under `total_context_budget` — if yes, skip.

### Files Not Affected (no changes needed)

| File | Reason |
|---|---|
| `CLAUDE.md` | Project-specific, never modified |
| `context/SYSTEM.md` | Credentials, never modified |
| `context/stories/*` | Project work, never modified |
| `context/workflows/*` | Project workflows, never modified |
| `.claude/rules/context-enforcement.md` | No changes in this fix |
| `.claude/rules/context-window-monitoring.md` | No changes in this fix |

### Verification Steps

After applying this fix, verify:

1. Run `/context-start` in the project
2. Confirm "Mandatory workflows (auto-loaded)" section appears if `context/workflows/` contains files with 🔒 markers
3. Confirm "Available workflows (load on-demand)" section lists non-mandatory workflows
4. Confirm token budget includes mandatory workflow tokens
5. Confirm rule #8 appears in `.claude/rules/core-rules.md`

---

## Evidence (Original Report)

**Discovered in project:** `triptaste/landing-page`

**Workflow files exist but were NOT tracked:**
```
context/workflows/user-approval.md
context/workflows/gemini-cli.md (contains 🔒 MANDATORY rules)
context/workflows/gemini-memory.md
context/workflows/hybrid-workflow.md (contains 🔒 INVIOLABLE rules)
```

**Result:** Agent violated hybrid-workflow.md rules by attempting direct code generation instead of using Gemini CLI workflow.

---

## Impact

**Severity:** HIGH

- Causes rule violations (hybrid workflow, gemini CLI integration)
- Wastes tokens by not using proper agent delegation
- Breaks context engineering principles
- Agent operates without awareness of mandatory workflows
- User must manually remind agent of workflow rules

---

## Implementation Tasks

**Phase 1: Fix Current Bug**
- [x] Update `/context-start` skill to scan `context/workflows/`
- [x] Add workflow parser to detect 🔒 MANDATORY/INVIOLABLE markers
- [x] Auto-load mandatory workflows during session start
- [x] Add "Mandatory Workflows" section to session status report
- [x] List available (non-mandatory) workflows
- [x] Update token budget calculations
- [x] Update context engineering documentation
- [x] Add workflow metadata standards to CONTEXT-SCHEMA.yaml
- [ ] Test with triptaste/landing-page project
- [ ] Verify mandatory workflows are followed

**Phase 2: Create Update Skill**
- [x] Design `/context-update` skill specification
- [x] Create update detection logic
- [x] Implement backup mechanism
- [x] Create smart merge for CLAUDE.md (preserve customizations)
- [x] Add diff display functionality
- [x] Implement apply logic
- [x] Add rollback capability
- [x] Add fix manifest to bug docs
- [ ] Test on triptaste/landing-page project
- [ ] Document update process

---

## Notes

- Discovered during Story 007 implementation in triptaste/landing-page
- Agent attempted direct code generation instead of using Gemini CLI
- Violated 🔒 INVIOLABLE rules in hybrid-workflow.md
- User correctly identified the context engineering gap
- User requested update mechanism to simplify applying fixes to existing projects
