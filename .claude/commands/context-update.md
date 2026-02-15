# Context Engineering - Update Implementation

Apply context engineering bug fixes and updates to an existing project by reading fix manifests from the skill repo.

## Usage

```
/context-update [--check|--apply|--diff]
```

**Flags:**
- `--check` (default) - Report available fixes and what would change
- `--diff` - Show detailed changes for each fix
- `--apply` - Apply fixes with automatic backup

## Instructions

When the user runs this command, follow these steps:

### Step 1: Verify Context Engineering Exists

Check the project root for context engineering structure:
- `CLAUDE.md` exists
- `.claude/commands/` directory exists
- `context/` directory exists

If NONE exist:
"No context engineering structure detected. Run `/context-init` to set up from scratch."
Stop here.

### Step 2: Locate or Clone Skill Source

The agent needs the `context-engineering-skill` repo to read fix manifests and source files.

**Check in this order:**

1. **Local copy in project:** Is `context-engineering-skill/` present in the project root?
2. **Sibling directory:** Is `context-engineering-skill/` a sibling of the project root?
3. **Clone from GitHub:** If not found locally, clone it:
   ```bash
   git clone https://github.com/arturosalazar/context-engineering-skill.git /tmp/context-engineering-skill
   ```
   Use `/tmp/context-engineering-skill` as the source path for this session.
4. **If clone fails:** Ask the user: "Could not clone the skill repo. Provide the local path to your context-engineering-skill repo:"

**If source already exists locally, pull latest:**
```bash
cd [skill-source-path] && git pull origin main
```
If pull fails (no network, etc.), continue with the current local version and warn:
"Could not pull latest. Using local version — it may not include the newest fixes."

Store the resolved path as `SKILL_SOURCE` for subsequent steps.

### Step 3: Read Fix Manifests

Read all bug fix documents from `SKILL_SOURCE/docs/bugs/*.md`.

For each bug doc:
1. Read the `<metadata>` block at the top
2. Extract: `id`, `status`, `severity`, `fixed_in`, `affects`
3. Find the **Fix Manifest** section (heading `## Fix Manifest`)
4. Parse the manifest to understand:
   - **Files to Replace**: Files that can be safely copied from source to project
   - **Files to Merge**: Files requiring targeted changes (with detection logic to skip if already applied)
   - **Verification Steps**: How to confirm the fix was applied

**Skip bug docs where:**
- `<status>` is not `FIXED` (only apply completed fixes)
- All changes in the manifest are already detected as applied in the project

### Step 4: Detect Already-Applied Fixes

For each fix manifest, run the **Detection** checks described in the manifest:

- For "Files to Replace": Compare source file against project file — if identical (or project file is newer), mark as already applied
- For "Files to Merge": Run each detection check (e.g., "Check if file contains X") — if detection passes, that change is already applied

Classify each bug fix as:
- **Available**: One or more changes from this fix are not yet applied
- **Already Applied**: All changes are detected as present
- **Partial**: Some changes applied, some not

### Step 5: Compare Commands and Templates

Beyond bug-specific fixes, also compare all command files and templates:

| Source File | Project File | Category |
|---|---|---|
| `commands/context-start.md` | `.claude/commands/context-start.md` | Always safe |
| `commands/context-init.md` | `.claude/commands/context-init.md` | Always safe |
| `commands/context-ingest.md` | `.claude/commands/context-ingest.md` | Always safe |
| `commands/context-refactor.md` | `.claude/commands/context-refactor.md` | Always safe |
| `commands/context-update.md` | `.claude/commands/context-update.md` | Always safe |

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
     - Adds workflow scanning (Step 3)
     - Adds mandatory workflow reporting in session status
     - Updates token budget to include workflows

  2. Merge .claude/rules/core-rules.md
     + Add rule #8: "ALWAYS check context/workflows/ for mandatory workflows"

  3. Merge context/CONTEXT-SCHEMA.yaml
     + Add mandatory_workflows tier (3,000 token budget)
     + Update total_context_budget to include workflows

---

[For command updates that are not part of a bug fix:]

--- context-update.md ---
Status: NEW
  This command does not exist in your project. It will be created.

---

Run '/context-update --apply' to apply these updates
```

#### Apply Mode (`--apply`)

**Step 6a: Create Backup**

1. Create backup directory: `.claude/backup/[YYYY-MM-DD-HHmmss]/`
2. Copy ALL project files that will be modified into the backup directory, preserving relative paths
3. Confirm backup was created

**Step 6b: Apply Bug Fixes**

For each available bug fix, follow the fix manifest instructions:

**Files to Replace:**
- Copy source file to project location, overwriting the existing file

**Files to Merge:**
- Read the current project file
- Apply each change described in the manifest
- Use the **Detection** check to confirm each change — skip changes already present
- Preserve any project-specific content (custom rules, custom triggers, custom schema entries)

**Step 6c: Apply Command Updates**

For commands classified as NEW or UPDATED:
- Copy source file to `.claude/commands/`
- Commands contain no project-specific content and are always safe to replace

**Step 6d: Report Results**

```
=== Context Engineering Update Applied ===

Backup created: .claude/backup/[timestamp]/

Bug fixes applied:
  BUG-001: Workflow Tracking           APPLIED
    - Replaced context-start.md
    - Merged core-rules.md (added rule #8)
    - Merged CONTEXT-SCHEMA.yaml (added mandatory_workflows tier)

Commands updated:
  context-update.md                    CREATED
  [...]

Preserved (untouched):
  CLAUDE.md, context/SYSTEM.md, stories/, workflows/

Rollback:
  Files backed up to: .claude/backup/[timestamp]/
  To rollback: copy backup files back to their original locations

Next steps:
1. Review changes: git diff
2. Test the setup: /context-start
3. Commit if satisfied
```

### Step 7: Post-Update Guidance

After any mode, remind:

```
Tip: Run '/context-start' to reload your session with the updated context.
```

## Important Rules

**Source Management:**
- ALWAYS try to locate the skill repo locally before cloning
- If cloning, use `/tmp/context-engineering-skill` to avoid cluttering the project
- ALWAYS pull latest before reading fix manifests
- Only read bug docs with `<status>FIXED</status>` — never apply in-progress fixes

**Fix Manifests:**
- Fix manifests in `docs/bugs/*.md` are the source of truth for what to change
- Always follow the Detection logic to skip already-applied changes
- Never apply a change if detection shows it's already present

**Safety:**
- ALWAYS create backup before ANY modifications (apply mode)
- NEVER modify CLAUDE.md, SYSTEM.md, stories, or workflows
- NEVER delete project files
- Ask before overwriting files that appear to have project-specific customizations

**Merge Strategy:**
- For rules files: add new rules, update existing rule text, keep custom rules
- For schema files: add new sections, update budgets, keep custom entries
- When in doubt, show the user both versions and ask which to keep

**Compatibility:**
- Use same file paths and conventions as `/context-init`
- Backup directory: `.claude/backup/` (consistent with `.claude/` convention)
- Commands are always safe to replace (no project-specific content)
