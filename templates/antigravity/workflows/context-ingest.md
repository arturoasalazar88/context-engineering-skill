---
description: Intelligently add new context to the project, auto-categorizing and placing it according to context engineering principles
---

# Context Engineering - Ingest Content

Intelligently add new context to the project, auto-categorizing and placing it according to context engineering principles.

## Instructions

When the user runs this workflow, follow these steps:

### Step 1: Verify Context Engineering Structure

Check that the project has context engineering:
- `CLAUDE.md` exists at project root
- `.claude/rules/` directory exists
- `context/stories/` directory exists

If any are missing:
"No context engineering structure found. Run `/context-init` first to set up the project."
Stop here.

### Step 2: Determine Content Type

If the user provided content as an argument, analyze it first, then confirm the type.

Otherwise ask:

"What type of context are you adding?

A) **Story/Task** - New work to be done (feature, bug fix, improvement)
B) **Technical Document** - Architecture, API specs, database schemas, etc.
C) **Workflow Rule** - A process or guideline the agent should follow
D) **System Information** - Servers, deployment details, credentials
E) **Project Context** - General project information (conventions, patterns, learnings)
F) **Auto-detect** - Let me analyze the content and determine the type"

### Step 3: Get Content

- If file path was provided as argument: Read the file
- If content was pasted inline: Use it directly
- Otherwise ask: "Provide the content to ingest. You can:
  - Paste content directly
  - Give me a file path to read
  - Describe what you want to add"

### Step 4: Analyze Content

Read `context/CONTEXT-SCHEMA.yaml` for placement rules.

Analyze the content to:
1. Verify or correct the content type from Step 2
2. Extract key information
3. Identify if it should be split into multiple files
4. Check for any credentials (flag for SYSTEM.md only)

### Step 5: Determine Placement (Decision Tree)

Follow this decision tree to determine where the content goes:

**STORY/TASK:**
```
Is it a single discrete task?
  YES -> Create context/stories/BACKLOG-XXX-[slug].md
  NO (multiple related tasks) -> Break down:
    - Create parent overview if needed
    - Create separate BACKLOG-XXX-[slug].md for each task
    - Set blocked_by dependencies between them
```
Read `context/stories/INDEX.md` to determine the next available story ID.

**TECHNICAL DOCUMENT:**
```
What kind of technical content?
  Architecture    -> context/ARCHITECTURE.md
  API specs       -> context/API.md
  Database schema -> context/DATABASE.md
  Configuration   -> context/CONFIG.md
  Conventions     -> context/CONVENTIONS.md
  Other domain    -> context/[DOMAIN-NAME].md
```
If the file already exists, merge the new content into it.

**WORKFLOW RULE:**
```
Does it apply to EVERY session?
  YES -> .claude/rules/[name].md (auto-loaded)
    WARNING: This increases always-loaded token budget!
    Confirm with user before proceeding.
  NO (specific workflow) -> context/workflows/[name].md (on-demand)
```

**SYSTEM INFORMATION:**
```
ALWAYS -> context/SYSTEM.md
  If file exists: merge new info into existing sections
  If file doesn't exist: create from template
  CRITICAL: Credentials ONLY go here, nowhere else!
```

**PROJECT CONTEXT:**
```
What section does it belong to?
  New component      -> Add to Components table in CLAUDE.md
  Service status     -> Add to Status table in CLAUDE.md
  Key learning       -> Add to Key Learnings in CLAUDE.md
  New context file   -> Add to Context Files table in CLAUDE.md
  Other              -> Determine best fit or create new context file
```

### Step 6: Structure Content

Apply context engineering principles to format the content:

- **Convert prose to tables** where data has consistent fields
- **Extract key-value pairs** from narrative descriptions
- **Use checklists** for task items and requirements
- **Add metadata blocks** with dates and status
- **Remove redundancy** and compress verbose content
- **Ensure NO credentials** in non-SYSTEM files

If creating a story:
- Read `templates/story.template.md` for the structure
- Fill in: objective, tasks, acceptance criteria, compliance section

### Step 7: Preview Placement

Show the user a preview before creating:

```
I will place this content as follows:

Type: [Story/Rule/Technical Context/System Info/Project Context]
File: [full path]
Action: [Create new file / Update existing file]

Preview (first 20 lines):
---
[structured content preview]
---

Token impact: +[estimated] tokens
Budget status: [within budget / approaching limit / over budget]

Proceed? [Yes / No / Edit]
```

If user says "Edit": let them modify, then re-preview.
If user says "No": cancel and ask what to change.

### Step 8: Create or Update Files

If user approves:

1. **Create or update** the determined file with structured content
2. **If story created**: Add entry to `context/stories/INDEX.md` in the appropriate table (Active Stories or Backlog)
3. **If new context file created**: Consider adding it to the "Context Files" table in CLAUDE.md
4. **If rule added to .claude/rules/**: Warn about token budget increase
5. **If updating existing file**: Merge content, don't overwrite existing sections

### Step 9: Report

```
Context ingested!

Type: [type]
Location: [file path]
Action: [Created / Updated]
Token impact: +[estimated] tokens
Budget status: [within / approaching / over] budget

[If story] Story added to INDEX.md
[If context file] Added to CLAUDE.md reference table
[If rule] Token budget increased - verify compliance
```

## Important Rules

- NEVER put credentials anywhere except context/SYSTEM.md
- Always structure content (tables, key-value, checklists) - never dump raw prose
- Always preview before creating/modifying files
- Respect token budgets defined in CONTEXT-SCHEMA.yaml
- When updating existing files, merge - don't overwrite
- Story IDs must be sequential (read INDEX.md to find next ID)
