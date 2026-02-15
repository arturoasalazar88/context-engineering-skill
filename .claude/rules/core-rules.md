# Core Agent Rules

## Mandatory (Always Apply)

1. **NEVER mark tasks/bugs resolved without explicit user approval**
2. **ALWAYS present summary of work + evidence before requesting resolution**
3. **ALWAYS load context/stories/INDEX.md at session start**
4. **NEVER store secrets/passwords in CLAUDE.md or context files** (use SYSTEM.md)
5. **ALWAYS update story files at task milestones**
6. **ALWAYS follow context engineering principles** (see `.claude/rules/context-enforcement.md`)
7. **MONITOR context window usage** and end session before compaction (see `.claude/rules/context-window-monitoring.md`)
8. **ALWAYS check context/workflows/ for mandatory workflows at session start** (🔒 MANDATORY / 🔒 INVIOLABLE markers)

## When to Load Detailed Rules

- BEFORE marking tasks resolved -> Load `context/workflows/user-approval.md`
