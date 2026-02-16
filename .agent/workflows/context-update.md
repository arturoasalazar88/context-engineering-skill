---
description: Apply context engineering bug fixes and updates to an existing project by reading fix manifests from the skill repo
---

# Context Engineering - Update Implementation

Apply context engineering bug fixes and updates to an existing project by reading fix manifests from the skill repo.

## Usage

Flags the user may pass:
- `--check` (default) - Report available fixes and what would change
- `--diff` - Show detailed changes for each fix
- `--apply` - Apply fixes with automatic backup

## Instructions

When the user runs this workflow, follow these steps:

### Step 1: Verify Context Engineering Exists

Check the project root for context engineering structure:
- `CLAUDE.md` exists
- `.claude/commands/` directory exists
- `context/` directory exists

If NONE exist:
"No context engineering structure detected. Run `/context-init` to set up from scratch."
Stop here.

### Step 2: Fetch Fixes Manifest

**Method 1: GitHub Raw URL (Preferred)**

Try to fetch the fixes manifest directly from GitHub:
```
https://raw.githubusercontent.com/arturoasalazar88/context-engineering-skill/main/FIXES-MANIFEST.yaml
```

If successful:
- Parse the YAML to get available fixes list
- Store `raw_base_url` from the manifest for fetching files later
- Store repository URL for cloning if needed

**Method 2: Local Clone (Fallback)**

If GitHub fetch fails (no network, etc.):

1. **Check for local copy in this order:**
   - Project root: `context-engineering-skill/`
   - Sibling directory: `../context-engineering-skill/`
   - `/tmp/context-engineering-skill/`

2. **If not found locally, clone:**
   ```bash
   git clone https://github.com/arturoasalazar88/context-engineering-skill.git /tmp/context-engineering-skill
   ```

3. **If source exists, pull latest:**
   ```bash
   cd [skill-source-path] && git pull origin main
   ```

4. **If clone fails:** Ask user for local path

Store the resolved source as either:
- `SOURCE_TYPE=github` with `RAW_BASE_URL`
- `SOURCE_TYPE=local` with `SKILL_SOURCE` path

### Step 3: Read Fixes from Manifest

Parse the `FIXES-MANIFEST.yaml` obtained in Step 2:

For each fix entry in `fixes:`:
1. Extract metadata: `id`, `title`, `severity`, `status`, `fixed_in`
2. Parse `files_changed:` list to understand what needs updating
3. Note `verification:` steps for post-apply checks

**File change types:**
- `type: replace` - Safe to copy from source, overwrites project file
- `type: merge` - Requires targeted changes with detection logic

**Skip fixes where:**
- `status` is not `FIXED` (only apply completed fixes)
- All changes are already applied (detected in Step 4)

### Step 4: Check Applied Fixes Status

**Read project's applied fixes tracker:**
Check if `context/APPLIED-FIXES.yaml` exists in the project root.

**If it exists:**
- Parse the `applied_fixes:` list
- For each fix in FIXES-MANIFEST, check if its `id` is in applied list
- If found, mark as "Already Applied"

**If it doesn't exist:**
- Create it from template when applying fixes
- For now, manually detect by checking file content

**Manual detection (for merge-type changes):**
- Read the project file
- Check for the `line_marker` or `detection` string from manifest
- If found, that specific change is already applied

**Classify each fix:**
- **Available**: Not in applied list and changes not detected
- **Already Applied**: In applied list or all changes detected
- **Partial**: Some changes detected, some not (rare)

### Step 5: Compare Commands and Templates

Beyond bug-specific fixes, also compare all command files and templates:

| Source File | Project File | Category |
|---|---|---|
| `commands/context-start.md` | `.claude/commands/context-start.md` | Always safe |
| `commands/context-init.md` | `.claude/commands/context-init.md` | Always safe |
| `commands/context-ingest.md` | `.claude/commands/context-ingest.md` | Always safe |
| `commands/context-refactor.md` | `.claude/commands/context-refactor.md` | Always safe |
| `commands/context-update.md` | `.claude/commands/context-update.md` | Always safe |
| `commands/context-close.md` | `.claude/commands/context-close.md` | Always safe |

For each pair:
- **NEW**: Exists in source but not project
- **UPDATED**: Both exist, content differs
- **CURRENT**: Match (no update needed)

### Step 6: Execute Mode

#### Check Mode (default: `--check`)

```
=== Context Engineering Update Check ===

Source: [SKILL_SOURCE path]
Project: [current project path]

Bug fixes available:
  BUG-001: Workflow Tracking           [AVAILABLE / ALREADY APPLIED / PARTIAL]
  [... for each bug doc found]

Command updates:
  context-start.md                     [NEW / UPDATED / CURRENT]
  context-update.md                    [NEW / UPDATED / CURRENT]
  [... for each command]

Preserved (never modified):
  CLAUDE.md, context/SYSTEM.md, stories/, workflows/

Summary:
  Bug fixes to apply: X
  Commands to update: X
  Already current:    X

Run '/context-update --diff' to see detailed changes
Run '/context-update --apply' to apply updates
```

#### Diff Mode (`--diff`)

For each available bug fix, show the manifest details:

```
=== Context Engineering Update Diff ===

--- BUG-001: Workflow Tracking ---
Status: AVAILABLE
Severity: HIGH
Affects: context-start, core-rules, CONTEXT-SCHEMA

Changes:
  1. Replace .claude/commands/context-start.md
  2. Merge .claude/rules/core-rules.md
  3. Merge context/CONTEXT-SCHEMA.yaml
```

#### Apply Mode (`--apply`)

**Step 6a: Create Backup**
1. Create backup directory: `.claude/backup/[YYYY-MM-DD-HHmmss]/`
2. Copy ALL project files that will be modified into the backup directory
3. Confirm backup was created

**Step 6b: Apply Bug Fixes**
For each available bug fix, follow the fix manifest instructions.

**Step 6c: Apply Command Updates**
For commands classified as NEW or UPDATED:
- Copy source file to `.claude/commands/`
- Commands contain no project-specific content and are always safe to replace

**Step 6d: Update Applied Fixes Tracker**
After successfully applying a fix:
1. If `context/APPLIED-FIXES.yaml` doesn't exist, create from template
2. Add fix entry to `applied_fixes:` list
3. Add entry to `update_history:` list

**Step 6e: Report Results**

```
=== Context Engineering Update Applied ===

Backup created: .claude/backup/[timestamp]/

Bug fixes applied:
  BUG-001: Workflow Tracking           APPLIED

Commands updated:
  context-update.md                    CREATED

Preserved (untouched):
  CLAUDE.md, context/SYSTEM.md, stories/, workflows/

Next steps:
1. Review changes: git diff
2. Test the setup: /context-start
3. Commit if satisfied
```

## Important Rules

**Source Management:**
- PREFER GitHub raw URLs to fetch manifest and files (works without cloning)
- Use correct repository URL: `https://github.com/arturoasalazar88/context-engineering-skill`
- If GitHub fetch fails, fallback to local clone at `/tmp/context-engineering-skill`
- Only apply fixes with `status: FIXED`

**Safety:**
- ALWAYS create backup before ANY modifications (apply mode)
- NEVER modify CLAUDE.md, SYSTEM.md, stories, or workflows
- NEVER delete project files
- Ask before overwriting files with project-specific customizations

**Merge Strategy:**
- For rules files: add new rules, update existing rule text, keep custom rules
- For schema files: add new sections, update budgets, keep custom entries
- When in doubt, show both versions and ask which to keep
