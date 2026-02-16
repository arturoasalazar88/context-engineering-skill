---
description: Ensure all work is saved, verify compliance with context engineering standards, check for pending approvals, and close session cleanly
---

# Context Engineering - Close Session

Ensure all work is saved, verify compliance with context engineering standards, check for pending approvals, and report token savings from hybrid workflow usage.

## Usage

Flags the user may pass:
- (default) - Full session close with all checks and reports
- `--quick` - Fast check: unsaved work + compliance only (skips token savings and cleanup)

## Instructions

When the user runs this workflow, execute these steps in order:

### Step 1: Check for Unsaved Work

**Git Status Check:**
```bash
git status --short
```

Analyze the output:
- **Uncommitted changes**: List modified files
- **Untracked files**: List new files created during session
- **Staged but not committed**: List files ready to commit

**Active Story Check:**
Read `context/stories/INDEX.md` and identify:
- Stories marked as ACTIVE
- For each active story, read the story file and count completed vs total tasks

**Report Format:**
```
=== Unsaved Work Check ===

Git status:
  Modified:   X files [list filenames]
  Untracked:  X files [list filenames]
  Staged:     X files [list filenames]

Active stories:
  ACTIVE-XXX: [Title] - X/Y tasks completed

Unpushed commits:
  X commits ahead of origin
```

### Step 2: Check for Pending Approvals

**Load the user-approval workflow:**
Read `context/workflows/user-approval.md` if it exists.

**Check story files for approval compliance:**

1. **Scan active story files** for tasks checked off during this session
2. **Check git diff** for story modifications:
   ```bash
   git diff context/stories/ACTIVE-*.md
   ```
3. **Verify approval evidence** in Progress Logs

**Report Format:**
```
=== Pending Approvals Check ===

✅ Work with documented approval:
  - Story XXX: [task description] (approved in progress log)

⚠️  Work pending approval:
  - Story XXX: [task description] (completed but no approval documented)
```

### Step 3: Verify Context Engineering Compliance

**3a. Static context budget:**

Count lines in always-loaded context files:
- `CLAUDE.md`
- All `.md` files in `.claude/rules/`

Calculate total lines and estimate tokens (lines x 10).

```
Static context budget:
  CLAUDE.md:                     XXX lines (~X,XXX tokens)
  core-rules.md:                  XX lines (~XXX tokens)
  context-enforcement.md:         XX lines (~XXX tokens)
  context-window-monitoring.md:   XX lines (~XXX tokens)
  ─────────────────────────────────────────
  Total:                         XXX lines (~X,XXX tokens)
  Target:                        250 lines (2,500 tokens)
  Status:                        [✅ Within budget / ❌ Over by XX lines]
```

**3b. Credential security scan:**

Search for common credential patterns in context files (NOT in SYSTEM.md):
- Search patterns: `password`, `api_key`, `secret_key`, `token=`, `Bearer `, `ssh-rsa`
- Files to scan: `CLAUDE.md`, `context/stories/*.md`, `.claude/rules/*.md`
- Exclude: `context/SYSTEM.md` (credentials belong there)

**3c. Story file compliance:**

For each active story file, verify:
- Uses structured format (checklists, tables)
- Has metadata block
- Has acceptance criteria
- Progress log is updated

**3d. File placement validation:**

Check that files created during session follow CONTEXT-SCHEMA.yaml rules.

**Overall Compliance Report:**
```
=== Context Engineering Compliance ===

✅ Static context budget:    XXX/250 lines (XX%)
✅ Credential security:      SECURE
✅ Story compliance:         X/X stories compliant
✅ File placement:           All files correctly placed

Overall: COMPLIANT
```

### Step 4: Calculate Token Savings (Hybrid Workflow)

**If `--quick` flag was used, skip this step.**

**Check if hybrid workflow is enabled:**
1. Check if `context/workflows/hybrid-workflow.md` exists
2. Check if `context/workflows/gemini-cli.md` exists
3. If either has 🔒 MANDATORY or 🔒 INVIOLABLE marker, workflow is "ENABLED"
4. If files exist without markers, workflow is "AVAILABLE (not mandatory)"
5. If files don't exist, workflow is "NOT ENABLED"

**If hybrid workflow is ENABLED or AVAILABLE:**

Scan session for sub-agent CLI usage and calculate estimated token savings.

```
=== Token Savings Report (Hybrid Workflow) ===

Hybrid workflow: [ENABLED / AVAILABLE / NOT ENABLED]

Sub-agent usage this session:
  Code generation:    X calls  →  ~X,XXX tokens saved
  Web fetch:          X calls  →  ~X,XXX tokens saved
  Script generation:  X calls  →  ~X,XXX tokens saved
  ─────────────────────────────────────────────
  Total invocations:  XX calls
  Estimated saved:    ~XX,XXX tokens
```

### Step 5: Session Statistics

**If `--quick` flag was used, skip this step.**

```
=== Session Statistics ===

Context window:
  Estimated usage:   ~XX,XXX tokens
  Zone:              [Green/Yellow/Red/Critical]
  Remaining capacity: ~XXX,XXX tokens

Files modified this session:
  Code files:      X
  Story files:     X
  Context files:   X
  Total:           X files

Stories:
  In progress:     X
  Completed:       X
  Blocked:         X
```

### Step 6: Cleanup Recommendations

```
=== Recommended Actions Before Closing ===

Required (blocking close):
  [ ] [Action based on findings]

Recommended (good practice):
  [ ] [Action based on findings]

No action needed:
  ✅ Context compliance verified
  ✅ All story files up to date
  ✅ No credential leaks detected
```

### Step 7: Final Report

```
=== Session Close Report ===

Unsaved work:     [✅ None / ⚠️ X items need attention]
Approvals:        [✅ All documented / ⚠️ X items pending]
Compliance:       [✅ COMPLIANT / ❌ X violations found]
Token savings:    [~XX,XXX tokens saved / Not applicable]
Cleanup:          [✅ No actions needed / ⚠️ X recommendations]

Session status:   [READY TO CLOSE / REQUIRES ATTENTION]

Context window:   ~XX,XXX / 200,000 tokens (XX%)
Zone:             [Green/Yellow/Red/Critical]

─────────────────────────────────────────────
Session closed. Context engineering standards [met/need attention].
Run '/context-start' at the beginning of your next session.
```

## Notes

- Run this workflow at the end of every session for proper cleanup
- All checks are non-destructive (read-only analysis)
- The workflow flags issues but does NOT auto-fix them (requires user decision)
- Token savings are estimates based on typical usage patterns
- The `--quick` flag skips Steps 4 and 5 for faster checks when token budget is tight
- This workflow complements `/context-start` as bookend session management

## Error Handling

- If git is not initialized: Skip git checks, note in report
- If story files are missing: Report as compliance issue
- If workflow files don't exist: Skip approval and token savings checks gracefully
- If any check fails: Report the failure, continue with remaining checks
- Always complete the final report even if individual checks error
