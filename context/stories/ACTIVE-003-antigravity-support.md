# Story 003: Add Antigravity IDE Support

<metadata>
  <id>003</id>
  <status>ACTIVE</status>
  <created>2026-02-15</created>
  <updated>2026-02-15</updated>
  <priority>High</priority>
</metadata>

## Objective

Enable context-engineering-skill to support both Claude Code and Antigravity IDE, allowing users to:
1. Install commands for Claude Code (`.claude/` directory)
2. Install skills for Antigravity IDE (`.antigravity/` directory)
3. Select both options during interactive installation
4. Seamlessly transition between Claude Code and Antigravity IDE using the same context engineering methodology

**Workflow:** Start session in Claude Code + VS Code → complete tasks → continue same session in Antigravity IDE with full context preservation.

## Research Phase

### Questions to Resolve

| Question | Status | Findings |
|----------|--------|----------|
| What is Antigravity IDE's directory structure? | 🔍 RESEARCHING | Similar to `.claude/`, likely `.antigravity/` |
| What format does Antigravity use for skills? | 🔍 RESEARCHING | SKILL.md files with YAML frontmatter + Markdown body |
| How are skills organized in Antigravity? | 🔍 RESEARCHING | Skill-specific directories under `.antigravity/skills/` or `.agent/skills/` |
| Are there documentation URLs for Antigravity? | 🔍 RESEARCHING | Need official Google Antigravity IDE docs |
| What's the command invocation format? | 🔍 RESEARCHING | Likely `/skill-name` similar to Claude Code |
| How does Antigravity handle rules/context? | 🔍 RESEARCHING | Unknown - needs investigation |

### Research Tasks

- [ ] Use Gemini web_search to find official Antigravity IDE documentation
- [ ] Identify Antigravity IDE's project structure conventions
- [ ] Determine SKILL.md format specification (YAML frontmatter schema)
- [ ] Understand skill loading mechanism in Antigravity
- [ ] Investigate context persistence between Claude Code and Antigravity sessions
- [ ] Check if Antigravity supports `.claude/rules/` or requires different format

## Implementation Tasks

### Phase 1: Template Adaptation

- [ ] Create `.antigravity/` template structure in `templates/`
- [ ] Convert command markdown files to Antigravity SKILL.md format
- [ ] Add YAML frontmatter to skill definitions (name, description, version, etc.)
- [ ] Organize skills in appropriate directory structure
- [ ] Create Antigravity-compatible rules format (if different from `.claude/rules/`)

### Phase 2: Installer Enhancement

- [ ] Modify `install.sh` to detect both `.claude/` and `.antigravity/` directories
- [ ] Add interactive menu for IDE selection:
  ```
  Which IDE(s) would you like to install for?
    [ ] Claude Code (.claude/)
    [ ] Antigravity IDE (.antigravity/)
    (Select one or both, use Space to toggle, Enter to confirm)
  ```
- [ ] Support installing to both simultaneously
- [ ] Handle update mode for both IDE types
- [ ] Create backup functionality for `.antigravity/` directory during updates

### Phase 3: Skill Conversion

Convert each command to Antigravity SKILL.md format:

- [ ] `/context-init` → `.antigravity/skills/context-init/SKILL.md`
- [ ] `/context-start` → `.antigravity/skills/context-start/SKILL.md`
- [ ] `/context-ingest` → `.antigravity/skills/context-ingest/SKILL.md`
- [ ] `/context-refactor` → `.antigravity/skills/context-refactor/SKILL.md`
- [ ] `/context-update` → `.antigravity/skills/context-update/SKILL.md`
- [ ] `/context-close` → `.antigravity/skills/context-close/SKILL.md`

**SKILL.md Format** (to be refined after research):
```markdown
---
name: context-start
version: 1.0.0
description: Start context engineering session with proper loading
author: Context Engineering Skill
category: context-management
---

# Context Engineering - Start Session

[Markdown instructions follow...]
```

### Phase 4: Documentation

- [ ] Update README.md with Antigravity IDE support information
- [ ] Document installation process for Antigravity
- [ ] Add workflow guide: Claude Code → Antigravity IDE transition
- [ ] Create troubleshooting section for Antigravity-specific issues
- [ ] Update docs/context-engineering-guide.md with IDE-agnostic guidance

### Phase 5: Testing

- [ ] Test Claude Code installation (ensure no regression)
- [ ] Test Antigravity IDE installation
- [ ] Test dual installation (both IDEs at once)
- [ ] Verify skill invocation in Antigravity IDE
- [ ] Test context persistence when switching between IDEs
- [ ] Validate that `context/` directory is IDE-agnostic

## Technical Design

### Directory Structure (After Implementation)

```
context-engineering-skill/
├── .claude/                      # Already exists
│   ├── commands/                 # Claude Code commands
│   └── rules/                    # Claude Code rules
├── .antigravity/                 # NEW - Antigravity IDE
│   ├── skills/                   # NEW - Antigravity skills
│   │   ├── context-init/
│   │   │   └── SKILL.md
│   │   ├── context-start/
│   │   │   └── SKILL.md
│   │   ├── context-ingest/
│   │   │   └── SKILL.md
│   │   ├── context-refactor/
│   │   │   └── SKILL.md
│   │   ├── context-update/
│   │   │   └── SKILL.md
│   │   └── context-close/
│   │       └── SKILL.md
│   └── rules/                    # NEW - Antigravity rules (if needed)
├── context/                      # IDE-agnostic (unchanged)
│   ├── stories/
│   ├── workflows/
│   ├── CONTEXT-SCHEMA.yaml
│   └── MEMORY-PROTOCOL.md
├── templates/
│   ├── claude/                   # Existing templates
│   └── antigravity/              # NEW - Antigravity templates
│       ├── skills/
│       └── rules/
└── install.sh                    # Enhanced installer
```

### Install.sh Enhancements

**New Interactive Flow:**

1. Mode selection: Install / Update
2. Target project path input
3. IDE detection or selection:
   - Auto-detect existing: `.claude/` or `.antigravity/`
   - For new installs: Interactive checkbox menu
4. Install/update files for selected IDE(s)
5. Display IDE-specific next steps

**Key Features:**
- Support multiple IDE selections (not mutually exclusive)
- Preserve existing installations when adding new IDE
- Separate backup directories for each IDE type
- IDE-agnostic context/ directory (never modified)

## Cross-IDE Workflow

**Example Session:**

```bash
# Day 1: Claude Code (VS Code)
/context-start
# Work on Story 003...
/context-close

# Day 2: Antigravity IDE
/context-start
# Session resumes with full context from Day 1
# Continue work on Story 003...
/context-close
```

**Key Principle:** The `context/` directory is IDE-agnostic. Stories, workflows, rules, and memory layers work identically across both IDEs.

## Blockers

| Blocker | Status | Resolution |
|---------|--------|------------|
| Antigravity IDE documentation not found | 🔍 OPEN | Continue web research, check Google Cloud docs |
| SKILL.md format specification unknown | 🔍 OPEN | Analyze examples, infer from web search results |
| Antigravity rules format uncertain | 🔍 OPEN | Test with minimal example once format determined |

## Decisions Made

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-02-15 | Use interactive installer (no CLI flags) | Better UX, prevents errors, allows multi-selection |
| 2026-02-15 | Keep `context/` directory IDE-agnostic | Enables seamless IDE switching, single source of truth |
| 2026-02-15 | Create separate template directories | Clean separation, easier maintenance |
| 2026-02-15 | Use SKILL.md naming for Antigravity | Aligns with research findings, follows IDE convention |

## Context Engineering Compliance

- [x] Story file uses structured format (checklists, tables, YAML)
- [x] No credentials in story file
- [x] Acceptance criteria are clear and measurable
- [x] Memory layer identified: **Project** (affects installation, IDE support)
- [x] New files follow CONTEXT-SCHEMA.yaml placement rules
- [x] Token budget impact assessed: ~200 tokens for story, ~2K tokens for new templates

## Acceptance Criteria

- [ ] install.sh supports interactive IDE selection (Claude Code, Antigravity, or both)
- [ ] Antigravity SKILL.md files created for all 6 commands
- [ ] YAML frontmatter follows Antigravity specification
- [ ] Installation to `.antigravity/skills/` works correctly
- [ ] Update mode works for Antigravity installations
- [ ] README documents Antigravity IDE support
- [ ] Claude Code installation remains unchanged (no regression)
- [ ] `context/` directory works identically for both IDEs
- [ ] Manual testing confirms skills load and execute in Antigravity IDE

## Next Actions

1. **IMMEDIATE:** Use Gemini to fetch official Antigravity IDE documentation
   ```bash
   gemini -m gemini-2.5-flash 'web_fetch(url="[antigravity-docs-url]", query="skill format and structure")'
   ```

2. **Research:** Determine SKILL.md YAML frontmatter schema

3. **Design:** Create SKILL.md template with proper format

4. **Implement:** Modify install.sh with interactive IDE selection

5. **Test:** Validate dual installation works correctly

## Progress Log

| Date | Update |
|------|--------|
| 2026-02-15 | Story created. Initial research via Gemini web_search completed. Found `.antigravity` references similar to `.claude`. SKILL.md format with YAML frontmatter identified. |

## Outcome

[To be completed upon story resolution]
