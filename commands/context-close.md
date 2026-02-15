# Context Engineering - Close Session

Ensure all work is saved, verify compliance with context engineering standards, check for pending approvals, and report token savings from hybrid workflow usage.

## Usage

```
/context-close [--quick]
```

**Flags:**
- (default) - Full session close with all checks and reports
- `--quick` - Fast check: unsaved work + compliance only (skips token savings and cleanup)

## Instructions

When the user runs this command, execute these steps in order:

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
  ACTIVE-XXX: [Title] - X/Y tasks completed

Unpushed commits:
  X commits ahead of origin
```

### Step 2: Check for Pending Approvals

**Load the user-approval workflow:**
Read `context/workflows/user-approval.md` if it exists.

**Check story files for approval compliance:**

1. **Scan active story files** for tasks checked off during this session:
   - Read each ACTIVE-*.md story file
   - Identify tasks marked as completed (`- [x]`)
   - Cross-reference with the story's Progress Log for approval entries

2. **Check git diff for story modifications:**
   ```bash
   git diff context/stories/ACTIVE-*.md
   ```
   - Identify tasks that changed from `- [ ]` to `- [x]` in this session
   - These represent work that was marked complete

3. **Verify approval evidence:**
   - Check if the Progress Log contains approval entries matching completed tasks
   - Look for entries like: "approved", "user approved", "LGTM", "confirmed"
   - Flag tasks marked complete without corresponding approval entry

**Report Format:**
```
=== Pending Approvals Check ===

✅ Work with documented approval:
  - Story XXX: [task description] (approved in progress log)

⚠️  Work pending approval:
  - Story XXX: [task description] (completed but no approval documented)

Story files checked: X
Tasks completed this session: X
Tasks with approval evidence: X
```

If tasks completed without approval:
```
⚠️  USER-APPROVAL WORKFLOW REMINDER

The following tasks were marked complete without documented approval.
Per user-approval.md workflow:

1. Present work summary with evidence to user
2. Request explicit approval before marking complete
3. Document approval in story Progress Log

Recommendations:
  [ ] Review completed work with user
  [ ] Document approvals in story progress logs
```

### Step 3: Verify Context Engineering Compliance

**Run all mandatory checks from context-enforcement.md:**

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
  [additional rule files]
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

```
Credential security:
  CLAUDE.md:       [✅ Clean / ❌ Potential credential found at line XX]
  Story files:     [✅ Clean / ❌ Potential credential found in FILE:LINE]
  Rules files:     [✅ Clean / ❌ Potential credential found in FILE:LINE]
  Status:          [SECURE / ⚠️ REVIEW NEEDED]
```

**3c. Story file compliance:**

For each active story file, verify:
- Uses structured format (checklists, tables)
- Has metadata block
- Has acceptance criteria
- Progress log is updated

```
Story compliance:
  ACTIVE-XXX.md:   [✅ Compliant / ⚠️ Missing: progress log update]
  ACTIVE-XXX.md:   [✅ Compliant / ⚠️ Missing: acceptance criteria]
  Status:          [COMPLIANT / NEEDS ATTENTION]
```

**3d. File placement validation:**

Check that files created during session follow CONTEXT-SCHEMA.yaml rules:
- Stories in `context/stories/` with proper prefix
- Workflows in `context/workflows/`
- Rules in `.claude/rules/`
- No new files in always-loaded locations (unless intentional)

```
File placement:
  New files this session: X
  Correctly placed:       X
  Misplaced:              X [list if any]
  Status:                 [COMPLIANT / ⚠️ REVIEW NEEDED]
```

**Overall Compliance Report:**
```
=== Context Engineering Compliance ===

✅ Static context budget:    XXX/250 lines (XX%)
✅ Credential security:      SECURE
✅ Story compliance:         X/X stories compliant
✅ File placement:           All files correctly placed

Overall: COMPLIANT
```

If any violations:
```
❌ COMPLIANCE VIOLATIONS DETECTED

1. [Specific violation with file path]
   Remediation: [Specific steps to fix]

2. [Next violation...]
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

1. **Scan session for Gemini CLI usage:**
   Review the conversation history for bash commands containing:
   - `gemini -m gemini-2.5-pro` (code generation calls)
   - `gemini -m gemini-2.5-flash` (web fetch, quick commands)
   - `gemini` followed by code generation patterns
   - Context7 MCP tool calls (`mcp__context7__`)

2. **Count invocations by type:**

   | Type | Pattern | Est. Savings per Call |
   |------|---------|----------------------|
   | Code generation | `gemini -m gemini-2.5-pro` + code output | ~500 tokens |
   | Web fetch/docs | `gemini -m gemini-2.5-flash` + URL/docs | ~300 tokens |
   | Script generation | `gemini` + bash/python/Dockerfile output | ~800 tokens |
   | Command execution | `gemini` + YOLO/exec patterns | ~200 tokens |

3. **Calculate totals:**

**Report Format:**
```
=== Token Savings Report (Hybrid Workflow) ===

Hybrid workflow: ENABLED (🔒 loaded at session start)

Gemini CLI usage this session:
  Code generation (gemini-2.5-pro):    X calls  →  ~X,XXX tokens saved
  Web fetch (gemini-2.5-flash):        X calls  →  ~X,XXX tokens saved
  Script generation:                    X calls  →  ~X,XXX tokens saved
  Command execution (YOLO):             X calls  →  ~X,XXX tokens saved
  ─────────────────────────────────────────────────────────────────
  Total Gemini invocations:            XX calls
  Estimated tokens saved:              ~XX,XXX tokens (XX% of 200K)

Context7 integration:
  Queries made: X
  Libraries researched: [library1, library2]

Quality metrics:
  [✅/❌] Context7 used before code generation
  [✅/❌] Web fetch used for documentation
  [✅/❌] Scripts generated via Gemini (not Claude)
  [✅/❌] Commands executed via Gemini YOLO mode
```

**Note on estimates:**
Token savings are approximate. Estimates based on:
- Code generation: Claude ~550 tokens to generate vs ~50 tokens to receive result
- Web fetch: Claude ~330 tokens to fetch+process vs ~30 tokens for summary
- Script generation: ~850 tokens offloaded entirely
- Command execution: ~250 tokens for execution+analysis vs ~50 for results

**If hybrid workflow is NOT ENABLED:**
```
=== Token Savings Report ===

Hybrid workflow: NOT ENABLED
No Gemini CLI workflows detected in context/workflows/.

To enable token savings through hybrid workflow:
1. Create context/workflows/gemini-cli.md with 🔒 MANDATORY marker
2. Create context/workflows/hybrid-workflow.md with 🔒 INVIOLABLE marker
3. Restart session with /context-start

Estimated potential savings: 60-70% of code generation tokens
```

### Step 5: Session Statistics

**If `--quick` flag was used, skip this step.**

**Gather session metrics:**

1. **Context window usage:**
   - Estimate current token usage based on conversation length
   - Determine zone: Green (0-100K), Yellow (100K-140K), Red (140K-160K), Critical (160K+)

2. **Files modified:**
   ```bash
   git diff --name-only
   git diff --cached --name-only
   ```
   Count by category: code files, story files, context files, other.

3. **Story progress:**
   - Count stories started, completed, still in progress

**Report Format:**
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
  Config files:    X
  Total:           X files

Stories:
  In progress:     X
  Completed:       X
  Blocked:         X

Token efficiency:
  Claude tokens used:    ~XX,XXX (estimated)
  Gemini tokens saved:   ~XX,XXX (estimated)
  Efficiency gain:       XX%
```

### Step 6: Cleanup Recommendations

Based on results from all previous steps, generate actionable recommendations:

```
=== Recommended Actions Before Closing ===

Required (blocking close):
  [ ] [Action based on findings - e.g., "Commit 3 modified files"]
  [ ] [Action based on findings - e.g., "Request approval for Story 008 tasks"]
  [ ] [Action based on findings - e.g., "Update ACTIVE-008 progress log"]

Recommended (good practice):
  [ ] [Action based on findings - e.g., "Push 2 unpushed commits"]
  [ ] [Action based on findings - e.g., "Add key learnings to CLAUDE.md"]
  [ ] [Action based on findings - e.g., "Clean Gemini session memory"]

No action needed:
  ✅ Context compliance verified
  ✅ All story files up to date
  ✅ No credential leaks detected
```

**Dynamic recommendations based on findings:**
- If uncommitted changes → "Commit changes: suggest specific files"
- If unpushed commits → "Push to remote: git push"
- If tasks completed without approval → "Request user approval for [task]"
- If story progress log not updated → "Update [story file] progress log"
- If over token budget → "Reduce static context by X lines"
- If credential found → "Move credential from [file] to context/SYSTEM.md"
- If Gemini was used → "Clear Gemini session memory"

### Step 7: Gemini Memory Cleanup (Conditional)

**Only run this step if Gemini CLI was used during the session (detected in Step 4).**

```
=== Gemini Memory Cleanup ===

Gemini CLI was used this session. To clear ephemeral memory, run:
```

Provide the cleanup command:
```bash
gemini -m gemini-2.5-pro "Session ending. Forget ALL memories from this session. Clear all saved context. Confirm cleanup complete."
```

Then suggest verification:
```bash
gemini -m gemini-2.5-pro "What memories do you have from the current session?"
```

Expected: "I have no saved memories from a previous session."

**If Gemini was NOT used, skip this step entirely.**

### Step 8: Final Report

Compile all findings into a single summary:

```
=== Session Close Report ===

Unsaved work:     [✅ None / ⚠️ X items need attention]
Approvals:        [✅ All documented / ⚠️ X items pending]
Compliance:       [✅ COMPLIANT / ❌ X violations found]
Token savings:    [~XX,XXX tokens saved / Not applicable]
Cleanup:          [✅ No actions needed / ⚠️ X recommendations]

Session status:   [READY TO CLOSE / REQUIRES ATTENTION]

[If REQUIRES ATTENTION:]
  Outstanding items:
  1. [Specific item from findings]
  2. [Specific item from findings]

Context window:   ~XX,XXX / 200,000 tokens (XX%)
Zone:             [Green/Yellow/Red/Critical]

─────────────────────────────────────────────
Session closed. Context engineering standards [met/need attention].
Run '/context-start' at the beginning of your next session.
```

## Notes

- Run this command at the end of every session for proper cleanup
- All checks are non-destructive (read-only analysis)
- The command flags issues but does NOT auto-fix them (requires user decision)
- Token savings are estimates based on typical usage patterns
- Gemini memory cleanup is only suggested when Gemini CLI was used
- The `--quick` flag skips Steps 4, 5 for faster checks when token budget is tight
- This command complements `/context-start` as bookend session management

## Error Handling

- If git is not initialized: Skip git checks, note in report
- If story files are missing: Report as compliance issue
- If workflow files don't exist: Skip approval and token savings checks gracefully
- If any check fails: Report the failure, continue with remaining checks
- Always complete the final report even if individual checks error

## Integration Points

| Workflow | How /context-close Uses It |
|----------|---------------------------|
| `user-approval.md` | Verifies tasks have documented approval |
| `hybrid-workflow.md` | Checks if enabled, calculates token savings |
| `gemini-cli.md` | Detects Gemini invocations, suggests memory cleanup |
| `context-enforcement.md` | Runs all compliance checks from this ruleset |
| `context-window-monitoring.md` | Reports final zone and capacity |
