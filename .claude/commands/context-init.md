# Context Engineering - Initialize Project

Initialize a project with a complete context engineering structure for Claude Code.

## Usage

```
/context-init
```

## Instructions

When the user runs this command, follow these steps in order. This is an interactive wizard - ask questions one at a time and wait for answers.

### Step 1: Detect Project State

Check the current project root for existing context engineering:
- Does `CLAUDE.md` exist?
- Does `.claude/rules/` directory exist?
- Does `context/stories/` directory exist?

**If ALL exist:**
Ask the user:
"This project already has context engineering structure. Would you like to:
A) Reinitialize (will overwrite existing structure)
B) Cancel"

If they choose Cancel, stop here.

**If SOME exist:**
"Partial context engineering detected. I'll complete the missing pieces while preserving existing files."

**If NONE exist:**
Continue to Step 2.

### Step 2: Gather Project Information

Ask these questions ONE AT A TIME. Wait for each answer before proceeding.

**Question 1 - Project Basics:**

"Let me set up context engineering for this project.

First, some basics:
- **Project name**: What should I call this project?
- **Purpose** (1-2 sentences): What does this project do?
- **Primary language(s)**: e.g., TypeScript, Python, Go"

**Question 2 - Components:**

"Does this project have multiple components/services?

A component is a distinct part of your system (API, frontend, bot, worker, database, etc.)

A) Single component - One app/service
B) Multiple components - List each with name and path

Examples:
- Single: 'A React app at ./'
- Multiple: 'Frontend at ./frontend, API at ./api, Worker at ./worker'"

**Question 3 - Infrastructure:**

"Do you have servers or infrastructure to document?

A) No - local development only
B) Yes - provide details for each server:
   - Name/Purpose
   - IP or hostname
   - SSH user
   - Deploy path

Note: Credentials will go in context/SYSTEM.md, never in CLAUDE.md"

**Question 4 - Technical Documents:**

"Do you have technical documents to provide? These help me generate better context and initial stories.

A) Yes - I'll provide file paths or paste content
B) No - I'll describe the project verbally
C) Later - set up structure first, add context later with /context-ingest

Accepted document types:
- Architecture docs, API specs, database schemas
- Requirements, user stories, meeting notes
- README files, design documents
- Any technical documentation"

**Question 5 - Context Onboarding** (skip if user chose 'Later' in Q4):

"Would you like to provide a context onboarding? This is your chance to explain the project in your own words.

Tell me about:
- Current state (new / in progress / mature)
- Key challenges or constraints
- Team structure (solo / small / large)
- Development workflow
- Anything else important

Or type 'skip' to continue with what I have."

**Question 6 - Optional Rules:**

"Which optional workflow rules do you want?

These are ALWAYS enabled (mandatory):
- Context engineering principles
- User approval protocol (never mark tasks resolved without asking)
- Context window monitoring

Optional (you can add more later with /context-ingest):
A) No additional rules - just the defaults
B) Custom workflow rules - describe what you need"

### Step 3: Process Documents (if provided in Q4)

If the user provided documents:
1. Read each document/file path
2. Extract structured information:
   - Architecture decisions
   - Tasks and requirements (will become stories)
   - Server/deployment info
   - Conventions and patterns
   - Configuration details
3. Apply context engineering principles:
   - Convert prose to tables
   - Extract key-value pairs
   - Structure hierarchically
   - Remove redundancy
4. Identify gaps and ask user to fill critical ones

### Step 4: Create Project Structure

Read templates from `context-engineering-skill/templates/` and create files at the project root.

**For each file, read the template, replace `{{PLACEHOLDERS}}` with gathered information, then create:**

1. **CLAUDE.md** (project root)
   - Template: `context-engineering-skill/templates/CLAUDE.template.md`
   - Replace: `{{PROJECT_NAME}}`, `{{PROJECT_SLUG}}`, `{{COMPONENTS_LIST}}`, `{{DATE}}`, `{{COMPONENTS_TABLE}}`, `{{SERVERS_TABLE}}`, `{{STATUS_TABLE}}`, `{{KEY_LEARNINGS}}`, `{{CUSTOM_COMMANDS}}`
   - If no servers: remove the Servers section entirely
   - If no status services: remove the Status section entirely
   - `{{ADDITIONAL_CONTEXT_FILES}}`: leave empty initially
   - `{{OPTIONAL_RULES}}`: add if user specified custom rules
   - `{{KEY_LEARNINGS}}`: leave as "[None yet - populated over time]"
   - MUST be under 150 lines

2. **.claude/rules/core-rules.md**
   - Template: `context-engineering-skill/templates/core-rules.template.md`
   - Replace: `{{OPTIONAL_RULE_TRIGGERS}}`, `{{OPTIONAL_RULE_REFERENCES}}`
   - If no optional rules: remove placeholder lines

3. **.claude/rules/context-enforcement.md**
   - Template: `context-engineering-skill/templates/context-enforcement.template.md`
   - No replacements needed (already generic)

4. **.claude/rules/context-window-monitoring.md**
   - Template: `context-engineering-skill/templates/context-window-monitoring.template.md`
   - No replacements needed (already generic)

5. **context/stories/INDEX.md**
   - Template: `context-engineering-skill/templates/INDEX.template.md`
   - Replace: `{{DATE}}`, `{{INITIAL_STORIES}}`, `{{BACKLOG_ITEMS}}`
   - Add generated stories if documents were processed

6. **context/CONTEXT-SCHEMA.yaml**
   - Template: `context-engineering-skill/templates/CONTEXT-SCHEMA.template.yaml`
   - Replace: `{{DATE}}`
   - Add project-specific per-task and on-demand file entries if relevant

7. **context/MEMORY-PROTOCOL.md**
   - Template: `context-engineering-skill/templates/MEMORY-PROTOCOL.template.md`
   - Replace: `{{DATE}}`

8. **context/SYSTEM.md**
   - Template: `context-engineering-skill/templates/SYSTEM.template.md`
   - Replace: `{{DATE}}`, server placeholders with gathered info
   - If no servers: keep template structure with placeholder comments

9. **context/workflows/user-approval.md** (always created)
   - Create a user approval workflow rule:
     ```
     # User Approval Protocol
     BEFORE marking any task/bug as resolved:
     1. Present summary of work done
     2. Show evidence (test results, file changes, etc.)
     3. Wait for explicit user approval
     4. Only then mark as resolved/completed
     ```

### Step 5: Generate Initial Stories (if documents were processed)

For each extracted task or requirement:
1. Read `context-engineering-skill/templates/story.template.md`
2. Fill in story details from extracted information
3. Create as `context/stories/BACKLOG-XXX-[slug].md`
4. Add entry to the INDEX.md stories table

### Step 6: Create directories that don't exist yet

Ensure these directories exist:
- `.claude/rules/`
- `context/`
- `context/stories/`
- `context/workflows/`

### Step 7: Report Results

Display a summary:

```
Context engineering initialized!

Structure created:
- CLAUDE.md (XX lines)
- .claude/rules/ (3 files)
- context/ (schema, memory protocol, system info)
- context/stories/ (index + N initial stories)
- context/workflows/ (user approval)

Components configured:
- [list from user input]

Token budget:
- Always-loaded: ~X,XXX tokens (target: <2,500)
- CLAUDE.md: XX lines (target: <150)

Initial stories created:
- [list if any, or "None - add tasks with /context-ingest"]

Next steps:
1. Review CLAUDE.md and adjust as needed
2. Add credentials to context/SYSTEM.md (never in CLAUDE.md!)
3. Start working: /context-start
4. Add new context anytime: /context-ingest
```

## Important Rules

- ONE CLAUDE.md at project root regardless of component count
- All components share the same context engineering structure
- Credentials ONLY in context/SYSTEM.md
- CLAUDE.md must be under 150 lines
- Always-loaded context must be under 2,500 tokens
- Use structured formats (tables, key-value, checklists) - never prose
- Context engineering and user approval rules are MANDATORY (cannot be disabled)
