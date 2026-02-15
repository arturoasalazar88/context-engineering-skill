# BUG-001: Context Engineering Workflow Tracking

<metadata>
  <id>BUG-001</id>
  <status>ACTIVE</status>
  <severity>HIGH</severity>
  <created>2026-02-14</created>
  <updated>2026-02-14</updated>
  <type>context-engineering-skill-bug</type>
  <affects>context-start skill</affects>
</metadata>

---

## Problem Statement

The `/context-start` skill does NOT properly track or report on workflow files in `context/workflows/`. This causes agents to:
1. Be unaware of mandatory workflow rules
2. Violate inviolable rules (like hybrid workflow, gemini-cli)
3. Miss critical context that should inform their behavior

---

## Evidence

**Discovered in project:** `triptaste/landing-page`

**Workflow files exist but are NOT tracked:**
```
context/workflows/user-approval.md
context/workflows/gemini-cli.md (contains 🔒 MANDATORY rules)
context/workflows/gemini-memory.md
context/workflows/hybrid-workflow.md (contains 🔒 INVIOLABLE rules)
```

**Current `/context-start` behavior:**
- ✅ Reports on CLAUDE.md and .claude/rules/*.md
- ✅ Reports on stories in context/stories/
- ❌ Does NOT report on context/workflows/*.md
- ❌ Does NOT track which workflows contain mandatory rules
- ❌ Does NOT alert when mandatory workflows should be loaded

**Result:** Agent violated hybrid-workflow.md rules by attempting direct code generation instead of using Gemini CLI workflow.

---

## Root Cause

The `/context-start` skill implementation:
1. Only scans `.claude/rules/` for always-loaded rules
2. Only scans `context/stories/` for task tracking
3. **Missing:** Does not scan or report on `context/workflows/`
4. **Missing:** No mechanism to identify mandatory workflows

---

## Impact

**Severity:** HIGH

**Why:**
- Causes rule violations (hybrid workflow, gemini CLI integration)
- Wastes tokens by not using proper agent delegation
- Breaks context engineering principles
- Agent operates without awareness of mandatory workflows
- User must manually remind agent of workflow rules

**Affected workflows:**
- Code generation (should use Gemini + Context7)
- Documentation fetching (should use Gemini web_fetch)
- Script generation (should use Gemini CLI)
- User approval protocols

---

## Proposed Solutions

### Option 1: Auto-Load Mandatory Workflows (Recommended)
Modify `/context-start` to:
1. Scan `context/workflows/*.md`
2. Parse files for markers: `🔒 MANDATORY`, `🔒 INVIOLABLE`, or metadata tags
3. Auto-load workflows with mandatory markers
4. Report them in session status under new section

**Implementation:**
```markdown
=== Session Context Status ===

Always-loaded context:
  CLAUDE.md:                     134 lines (~1,340 tokens)
  core-rules.md:                  20 lines (~200 tokens)
  [...]
  ------------------------------------------------
  Total static context:          271 lines (~2,710 tokens)

Mandatory workflows (auto-loaded):
  hybrid-workflow.md:            150 lines (~1,500 tokens) 🔒
  gemini-cli.md:                 120 lines (~1,200 tokens) 🔒
  ------------------------------------------------
  Total mandatory workflows:     270 lines (~2,700 tokens)

Available workflows (load on-demand):
  user-approval.md
  gemini-memory.md
```

**Token impact:** +2,500-3,000 tokens for mandatory workflows

**Pros:**
- Ensures mandatory rules are always followed
- Prevents rule violations
- Clear visibility of active workflows

**Cons:**
- Increases always-loaded token budget
- May need to adjust budget targets

---

### Option 2: Track & Alert (Lighter)
Modify `/context-start` to:
1. Scan `context/workflows/*.md`
2. List them in session report with metadata
3. Mark which contain mandatory markers
4. Provide alert: "⚠️ Mandatory workflows detected - load before code generation"

**Implementation:**
```markdown
Workflows detected:
| File | Type | Load |
|------|------|------|
| hybrid-workflow.md | 🔒 MANDATORY | Use /load-workflow |
| gemini-cli.md | 🔒 MANDATORY | Use /load-workflow |
| user-approval.md | On-demand | Load when needed |
```

**Token impact:** Minimal (~100 tokens for listing)

**Pros:**
- Low token cost
- Flexible loading

**Cons:**
- Agent might still miss or ignore workflows
- Requires manual loading step
- Still potential for violations

---

### Option 3: Hybrid Approach (Balanced)
1. **Always auto-load**: Workflows with `🔒 MANDATORY` or `🔒 INVIOLABLE`
2. **List but don't load**: Other workflows (on-demand)
3. **Smart detection**: Parse first 20 lines for markers
4. **Clear reporting**: Show what's loaded vs available

**Token impact:** ~2,500-3,000 tokens (only mandatory ones)

**Pros:**
- Best balance of compliance and token efficiency
- Mandatory rules always enforced
- Optional workflows available when needed
- Clear visibility

**Cons:**
- More complex implementation
- Need to define marker standards

---

## Recommended Solution: Option 3 (Hybrid)

**Reasoning:**
- Mandatory workflows MUST be loaded to prevent violations
- Optional workflows (like user-approval) can be on-demand
- Clear marker system (🔒) is already used in workflow files
- Token cost is justified by preventing rule violations

---

## New Skill Required: `/context-update`

### Purpose
Allow users to easily apply context engineering bug fixes and updates to existing project implementations.

### Problem Solved
- Users have to manually update CLAUDE.md, rules, skills when fixes are released
- No easy way to "upgrade" context engineering setup in existing projects
- Risk of version drift between skill repo and project implementations

### Command Specification

**Usage:**
```bash
/context-update [--check|--apply|--diff]
```

**Modes:**

1. **Check mode** (default):
```bash
/context-update
/context-update --check
```
- Scans current project structure
- Compares with latest context-engineering-skill repo
- Reports what would be updated
- Shows diffs for changed files
- Lists available fixes/improvements

2. **Diff mode:**
```bash
/context-update --diff
```
- Shows detailed diffs for each file
- Highlights breaking changes
- Shows new features added

3. **Apply mode:**
```bash
/context-update --apply
```
- Applies updates to project
- Backs up current files to `.claude/backup/YYYY-MM-DD/`
- Updates skills, rules, CLAUDE.md template sections
- Preserves project-specific customizations
- Reports what was changed

### Implementation Details

**What it updates:**

**Always safe to update:**
- `.claude/skills/` - Skill implementations
- `.claude/rules/` - Core rules (with backup)
- `context/CONTEXT-SCHEMA.yaml` - Schema definitions

**Conditional updates (preserves customizations):**
- `CLAUDE.md` - Only template sections marked with `<!-- AUTO-UPDATE -->`
- `context/stories/INDEX.md` - Only template section
- Workflow files - Only if not customized

**What it preserves:**
- Project-specific content in CLAUDE.md
- Active/Done stories
- Custom workflows
- SYSTEM.md (credentials)
- All project code

**Update process:**
1. Fetch latest from context-engineering-skill repo (or local path)
2. Compare versions/checksums
3. Identify changes
4. Create backup in `.claude/backup/YYYY-MM-DD-HHmmss/`
5. Apply updates (with merge strategy for CLAUDE.md)
6. Report changes
7. Suggest `/context-start` to reload

### Example Output

```markdown
=== Context Engineering Update Check ===

Current version: 1.0.0
Latest version: 1.1.0

Updates available:
✅ BUG-001: Workflow tracking in /context-start
✅ Feature: Mandatory workflow auto-loading
✅ New skill: /context-refactor

Files to update:
  .claude/skills/context-start.md     [MAJOR UPDATE]
  .claude/rules/core-rules.md         [MINOR UPDATE]
  CLAUDE.md (template sections)       [SAFE MERGE]

Breaking changes: None
New features: Workflow tracking, token monitoring improvements

Run '/context-update --diff' to see detailed changes
Run '/context-update --apply' to apply updates
```

### Metadata Tracking

Add to CLAUDE.md:
```markdown
<metadata>
  <project>triptaste-landing-page</project>
  <context-engineering-version>1.1.0</context-engineering-version>
  <last_updated>2026-02-14</last_updated>
  <auto-update-enabled>true</auto-update-enabled>
</metadata>
```

### Configuration

Add to `.claude/config.yaml` (optional):
```yaml
context_engineering:
  version: "1.1.0"
  auto_check_updates: true
  update_source: "local" # or "github"
  local_path: "/Users/user/repos/context-engineering-skill"
  preserve_customizations: true
  backup_before_update: true
```

---

## Implementation Tasks

**Phase 1: Fix Current Bug**
- [ ] Update `/context-start` skill to scan `context/workflows/`
- [ ] Add workflow parser to detect 🔒 MANDATORY/INVIOLABLE markers
- [ ] Auto-load mandatory workflows during session start
- [ ] Add "Mandatory Workflows" section to session status report
- [ ] List available (non-mandatory) workflows
- [ ] Update token budget calculations
- [ ] Update context engineering documentation
- [ ] Add workflow metadata standards to CONTEXT-SCHEMA.yaml
- [ ] Test with triptaste/landing-page project
- [ ] Verify mandatory workflows are followed

**Phase 2: Create Update Skill**
- [ ] Design `/context-update` skill specification
- [ ] Implement version tracking in CLAUDE.md metadata
- [ ] Create update detection logic
- [ ] Implement backup mechanism
- [ ] Create smart merge for CLAUDE.md (preserve customizations)
- [ ] Add diff display functionality
- [ ] Implement apply logic
- [ ] Add rollback capability
- [ ] Test on triptaste/landing-page project
- [ ] Document update process
- [ ] Create migration guides for breaking changes

**Phase 3: Distribution**
- [ ] Version the context-engineering-skill repo
- [ ] Add CHANGELOG.md
- [ ] Create release process
- [ ] Document how to use `/context-update`
- [ ] Add to skill catalog

---

## Workflow Metadata Standard (Proposed)

Add to workflow files:
```markdown
<metadata>
  <type>workflow</type>
  <enforcement>mandatory|optional</enforcement>
  <load>auto|on-demand</load>
  <tokens>~1500</tokens>
</metadata>
```

Or use emoji markers (simpler):
- `🔒 MANDATORY` or `🔒 INVIOLABLE` = auto-load
- No marker = on-demand

---

## Acceptance Criteria

**Bug Fix (Phase 1):**
- [ ] `/context-start` scans `context/workflows/` directory
- [ ] Mandatory workflows are auto-loaded
- [ ] Session status shows "Mandatory Workflows" section
- [ ] Available workflows are listed but not loaded
- [ ] Token budget calculations include mandatory workflows
- [ ] Documentation updated (README, CONTEXT-SCHEMA.yaml)
- [ ] Tested in real project (triptaste/landing-page)
- [ ] No rule violations in test sessions
- [ ] Token budget impact documented

**Update Skill (Phase 2):**
- [ ] `/context-update` command implemented
- [ ] Check mode works correctly
- [ ] Diff mode shows accurate diffs
- [ ] Apply mode safely updates files
- [ ] Backup mechanism works
- [ ] CLAUDE.md customizations preserved
- [ ] Version tracking functional
- [ ] Rollback capability works
- [ ] Tested on multiple projects
- [ ] Documentation complete

---

## Test Plan

**Phase 1 (Bug Fix):**
1. **Setup:** Use triptaste/landing-page project (has workflow files)
2. **Run:** Execute `/context-start`
3. **Verify:**
   - hybrid-workflow.md is auto-loaded
   - gemini-cli.md is auto-loaded
   - Session report shows mandatory workflows section
   - Other workflows listed as available
   - Agent follows hybrid workflow rules in code generation

**Phase 2 (Update Skill):**
1. **Setup:** Create test project with old context engineering version
2. **Run:** `/context-update --check`
3. **Verify:** Correctly identifies outdated files
4. **Run:** `/context-update --diff`
5. **Verify:** Shows accurate diffs
6. **Run:** `/context-update --apply`
7. **Verify:**
   - Files updated correctly
   - Backup created
   - Customizations preserved
   - Version metadata updated
8. **Run:** `/context-start`
9. **Verify:** New features work correctly

---

## Related Files

**Skill files to update:**
- `/context-start` skill implementation
- Documentation/README for skills

**New skill files:**
- `/context-update` skill (new)

**Schema files:**
- CONTEXT-SCHEMA.yaml (add workflow metadata, version tracking)

**Example workflows (for testing):**
- context/workflows/hybrid-workflow.md
- context/workflows/gemini-cli.md
- context/workflows/user-approval.md

---

## Priority: HIGH

**Why:**
- Currently causing rule violations
- Affects core functionality of context engineering
- Impacts token efficiency (should be using Gemini delegation)
- Breaks intended workflow patterns
- Blocks easy distribution of fixes to existing projects

**Assign to:** Skill maintainer
**Target:**
- Phase 1 (Bug fix): Next release (v1.1.0)
- Phase 2 (Update skill): Following release (v1.2.0)

---

## Notes

- Discovered during Story 007 implementation in triptaste/landing-page
- Agent attempted direct code generation instead of using Gemini CLI
- Violated 🔒 INVIOLABLE rules in hybrid-workflow.md
- User correctly identified the context engineering gap
- User requested update mechanism to simplify applying fixes to existing projects
