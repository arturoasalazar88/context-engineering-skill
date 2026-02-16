---
description: Audit an existing context engineering implementation and refactor it to match current best practices and templates
---

# Context Engineering - Refactor Implementation

Audit an existing context engineering implementation and refactor it to match current best practices and templates.

## Usage

Flags the user may pass:
- `--report-only` - Generate audit report without making changes
- `--auto` - Automatically apply all safe fixes without confirmation

## Instructions

When the user runs this workflow, follow these steps:

### Step 1: Verify Context Engineering Exists

Check the project root for context engineering structure:
- `CLAUDE.md` exists
- `.claude/rules/` directory exists
- `context/` directory exists

If NONE exist:
"No context engineering structure detected. Run `/context-init` to set up from scratch."
Stop here.

If SOME exist:
Continue with audit.

### Step 2: Load Templates for Comparison

Read the canonical templates from `templates/` to use as the standard:

| Template | Purpose |
|----------|---------|
| CLAUDE.template.md | Reference structure for CLAUDE.md |
| core-rules.template.md | Expected rules content |
| context-enforcement.template.md | Enforcement checklist standard |
| context-window-monitoring.template.md | Monitoring rules standard |
| INDEX.template.md | Stories index structure |
| CONTEXT-SCHEMA.template.yaml | Schema definition standard |
| story.template.md | Individual story format |

These templates define the "correct" structure. Compare the user's files against them.

### Step 3: Run Comprehensive Audit

Perform checks in order of severity. Record each finding with severity level.

#### 3.1 - Security Audit (CRITICAL)

| Check | How to Check | Fix If Found |
|-------|--------------|--------------|
| API keys in CLAUDE.md | Grep for patterns: `api[_-]?key`, `sk-`, `Bearer ` | Move to context/SYSTEM.md |
| Passwords in CLAUDE.md | Grep for: `password`, `passwd`, `pwd` | Remove, guide to secure storage |
| Tokens in CLAUDE.md | Grep for: `token`, `auth`, `secret` | Move to context/SYSTEM.md |
| API keys in .claude/rules/ | Same patterns | Move to context/SYSTEM.md |
| Credentials in stories/ | Same patterns | Move to context/SYSTEM.md |
| SSH keys in files | Grep for: `BEGIN.*PRIVATE KEY` | Remove, guide to secure storage |

> **CRITICAL**: If ANY credentials found, mark as CRITICAL severity and flag for immediate manual fix.

#### 3.2 - Structure Audit (HIGH)

| Check | Standard | How to Check |
|-------|----------|--------------|
| CLAUDE.md exists | Must exist at root | File check |
| CLAUDE.md line count | Target <150, max <200 | `wc -l CLAUDE.md` |
| .claude/rules/core-rules.md | Must exist | File check |
| .claude/rules/context-enforcement.md | Must exist | File check |
| .claude/rules/context-window-monitoring.md | Must exist | File check |
| Total rules lines | Target <150 | Count all .md in .claude/rules/ |
| context/stories/INDEX.md | Must exist | File check |
| context/CONTEXT-SCHEMA.yaml | Should exist | File check |
| context/MEMORY-PROTOCOL.md | Should exist | File check |
| context/SYSTEM.md | Should exist if servers/credentials | File check |

#### 3.3 - Token Budget Audit (HIGH)

Calculate token budget using same method as `/context-start`:

```
For each always-loaded file:
  - Count lines
  - Estimate tokens: lines × 10

Total = CLAUDE.md + all .claude/rules/*.md

Target: <2,500 tokens
Maximum: <3,000 tokens
```

If over target: Mark as HIGH severity.

#### 3.4 - Format Audit (MEDIUM)

Check CLAUDE.md structure against CLAUDE.template.md:

| Section | Required | Check Method |
|---------|----------|--------------|
| Metadata block | Yes | Look for `<metadata>` at top |
| "START HERE" reference | Yes | Grep for "START HERE.*INDEX.md" |
| Components table | If multi-component | Look for `## Components` + table |
| Servers table | If servers exist | Look for `## Servers` + table |
| Context Files table | Yes | Look for table with "Load When" column |
| Context Loading Tiers | Yes | Look for tier table (Always/Start/Task/Demand/Archive) |
| Core Rules section | Yes | Look for numbered rules list |
| How to Use section | Yes | Look for usage instructions |

Check rules files against templates:
- core-rules.md should have 7 mandatory rules
- context-enforcement.md should have session checklists
- context-window-monitoring.md should have zone table

#### 3.5 - Story System Audit (MEDIUM)

| Check | Standard | How to Check |
|-------|----------|--------------|
| Story naming | `STATUS-XXX-slug.md` format | Check all files in context/stories/ |
| Story prefixes | ACTIVE-, DONE-, BACKLOG-, BLOCKED- | Verify prefix usage |
| Story metadata | `<metadata>` block present | Check first 15 lines of each story |
| INDEX.md structure | Matches INDEX.template.md | Compare sections |

#### 3.6 - Prose vs Structure Audit (LOW)

Scan CLAUDE.md for prose paragraphs that should be tables:
- Look for paragraphs >3 lines in main sections
- Suggest converting to tables if data has consistent fields

### Step 4: Generate Audit Report

Create structured report with findings grouped by severity:

```
=== Context Engineering Audit Report ===

Project: [Name from CLAUDE.md or "Unknown"]
Audit Date: [YYYY-MM-DD]

Overall Status: [COMPLIANT / NEEDS ATTENTION / CRITICAL ISSUES]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CRITICAL Issues (security - fix immediately):
[If none: "✓ No critical security issues found"]

[For each critical issue:]
  ⚠️  [Issue description]
      File: [file:line if applicable]
      Fix: [What needs to be done]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

HIGH Priority Issues (structure/budget):
[If none: "✓ No high-priority issues found"]

[For each high issue:]
  ▲ [Issue description]
     Current: [current state]
     Expected: [expected state]
     Fix: [How to fix]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MEDIUM Priority Issues (format/conventions):
[If none: "✓ No medium-priority issues found"]

[For each medium issue:]
  ● [Issue description]
     Suggestion: [How to improve]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

LOW Priority Issues (style/optimization):
[If none: "✓ No low-priority issues found"]

[For each low issue:]
  · [Issue description]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Token Budget Analysis:

  Always-Loaded Files:
    CLAUDE.md:                    XXX lines (~X,XXX tokens)
    core-rules.md:                XXX lines (~XXX tokens)
    context-enforcement.md:       XXX lines (~XXX tokens)
    context-window-monitoring.md: XXX lines (~XXX tokens)
    [any other .claude/rules/*.md files]
    ────────────────────────────────────────────────
    Total:                        XXX lines (~X,XXX tokens)

  Budget Status:
    Target:    <250 lines (<2,500 tokens)
    Maximum:   <300 lines (<3,000 tokens)
    Status:    [✓ Within target / ⚠ Over target / ✗ Over maximum]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Summary:
  Critical:  X issues
  High:      X issues
  Medium:    X issues
  Low:       X issues

Recommendation: [Next action based on severity]
```

### Step 5: Determine Action Mode

**If --report-only flag was used:**
- Display report and stop here
- "To apply fixes, run `/context-refactor` without --report-only"

**If --auto flag was used:**
- Skip to Step 6, apply all safe fixes automatically
- "Applying all safe fixes automatically..."

**Otherwise (interactive mode), ask:**
```
How would you like to proceed?

A) Auto-fix safe issues (structure, missing files, renames)
B) Interactive fix (review each issue before applying)
C) Cancel (just show me the report)
```

### Step 6: Apply Fixes

Based on mode, apply fixes in severity order (Critical → High → Medium → Low).

**IMPORTANT: Before any file modifications:**
1. Create backup directory: `.backup/context-refactor-[timestamp]/`
2. Copy ALL files that will be modified to backup
3. Add `.backup/` to .gitignore if not already there

#### 6.1 - Safe Fixes (Auto-fixable)

| Issue | Fix Method | Risk Level |
|-------|------------|------------|
| Missing core-rules.md | Copy from template, replace `{{PLACEHOLDERS}}` | Safe |
| Missing context-enforcement.md | Copy from template | Safe (no placeholders) |
| Missing context-window-monitoring.md | Copy from template | Safe (no placeholders) |
| Missing CONTEXT-SCHEMA.yaml | Copy from template, replace `{{DATE}}` | Safe |
| Missing MEMORY-PROTOCOL.md | Copy from template, replace `{{DATE}}` | Safe |
| Missing metadata block in CLAUDE.md | Add to top from template | Safe |
| Wrong story naming | Rename files: `story-001.md` → `BACKLOG-001-story.md` | Safe |
| Missing story metadata | Add `<metadata>` block to top | Safe |
| Missing INDEX.md | Create from INDEX.template.md | Safe |

#### 6.2 - Interactive Fixes (Need confirmation)

| Issue | Fix Options | Why Interactive |
|-------|-------------|-----------------|
| Credentials found | Preview + offer to move to SYSTEM.md | Security sensitive |
| CLAUDE.md over 200 lines | Suggest files to split out | Content decision |
| Prose paragraphs | Show table conversion preview | Format preference |
| Duplicate content | Suggest consolidation | Content decision |
| Missing SYSTEM.md | Create template vs use existing file | May have custom format |

**For each interactive fix:**
1. Show current state
2. Show proposed change (preview or diff)
3. Ask: "Apply this fix? [Yes/No/Skip]"
4. If Yes: Apply and verify
5. If No: Ask "Would you like to fix manually?"
6. If Skip: Move to next issue

#### 6.3 - Manual Fixes (Guide only)

| Issue | Guidance |
|-------|----------|
| Exposed API key | "Found API key at [file:line]. Please:\n1. Move to context/SYSTEM.md\n2. Or store in .env file\n3. Never commit to git" |
| Structural mismatch | "Your structure differs significantly from standard. Consider:\n1. Run `/context-init` for clean setup\n2. Or manually align with templates" |
| Complex content issues | "Review [file] and consider:\n- [specific suggestions based on audit]" |

### Step 7: Verify Fixes

After applying fixes, re-run relevant audit checks:
- Recount lines and tokens
- Verify files exist where expected
- Check that issues are resolved

### Step 8: Final Report

```
=== Refactor Complete ===

Fixes Applied:
  Critical:  X issues → X fixed, X manual
  High:      X issues → X fixed, X manual
  Medium:    X issues → X fixed, X manual
  Low:       X issues → X fixed, X manual

Files Modified:
  ✓ CLAUDE.md [action taken]
  ✓ .claude/rules/core-rules.md [created from template]
  ✓ context/stories/BACKLOG-001-task.md [renamed]
  [... list all changes ...]

Files Created:
  ✓ .claude/rules/context-enforcement.md
  ✓ context/CONTEXT-SCHEMA.yaml
  [... list created files ...]

Backups Saved:
  Location: .backup/context-refactor-[timestamp]/
  Files: [count] files backed up

Token Budget:
  Before:  XXX lines (~X,XXX tokens) [over/under target]
  After:   XXX lines (~X,XXX tokens) [over/under target]
  Change:  [+/-XX tokens]

Remaining Issues (require manual fix):
  [List any that couldn't be auto-fixed]

Next Steps:
1. Review changes: git diff
2. Test the setup: /context-start
3. Commit if satisfied: git add -A && git commit -m "refactor: apply context engineering best practices"
4. Delete backups: rm -rf .backup/
```

## Important Rules

**File Safety:**
- ALWAYS create `.backup/` directory before ANY modifications
- NEVER modify files without backup
- ALWAYS verify backups were created successfully
- Add `.backup/` to .gitignore

**Security:**
- NEVER automatically move credentials (guide user instead)
- ALWAYS flag credential exposure as CRITICAL
- NEVER log or display actual credential values

**Templates:**
- ALWAYS read from `templates/`
- Use templates as source of truth for structure
- Replace `{{PLACEHOLDERS}}` with project-specific values when creating files
- For DATE placeholders: use current date in YYYY-MM-DD format

**Conservative Approach:**
- Only fix clear violations of documented standards
- When in doubt, report as INFO/SUGGESTION, not error
- Respect intentional deviations
- Don't impose style opinions beyond documented standards
