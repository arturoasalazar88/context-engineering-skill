# Memory Management Protocol

<metadata>
  <purpose>Operational guide for 4-layer memory management</purpose>
  <created>2026-02-14</created>
</metadata>

---

## 4-Layer Memory Architecture

### Layer 1: Session Memory (Ephemeral)

**Scope:** Current conversation only
**Storage:** In-context window (tokens)
**Lifetime:** Until compaction or session end

**Context Window Limits:**
- Total capacity: 200,000 tokens
- Safe limit: 140,000 tokens (~70%)
- Compaction threshold: 160,000 tokens (~80%)
- Critical zone: 160,000+ tokens

**Contains:**
- Recent messages (last 5-10 turns)
- Active tool results (temporary)
- Current decision state
- Working context for active task

**Management:**
- Keep last 5-10 message turns in full
- Clear tool outputs after processing (keep conclusions only)
- Compaction trigger: context approaching limits
- Summarize older turns into condensed block

---

### Layer 2: Working Memory (Task-Scoped)

**Scope:** Current story / bug
**Storage:** Story files (`context/stories/ACTIVE-*.md`)
**Lifetime:** Duration of the task

**Contains:**
- Objective
- Task checklist
- Progress log
- Decisions made with rationale
- Blockers
- Next steps

**Management:**
- Update at each milestone (not every small step)
- Record decisions with rationale
- Structure as checklists for quick scanning
- Survives session end, compaction, context resets

---

### Layer 3: Project Memory (Persistent)

**Scope:** Entire project, cross-session
**Storage:** CLAUDE.md + context/*.md files
**Lifetime:** Duration of the project

**Contains:**
- Project architecture
- Server information
- Key learnings
- Conventions and patterns
- Configuration schemas
- Troubleshooting guides

**Management:**
- CLAUDE.md = single entry point (always loaded, kept slim ~150 lines)
- Context files = domain knowledge (loaded on demand)
- Update learnings after significant sessions
- Prune outdated info quarterly
- Structure as tables/key-value, NOT prose

---

### Layer 4: Agent Identity Memory (Permanent)

**Scope:** Cross-project, agent-level
**Storage:** `~/.claude/projects/*/memory/MEMORY.md`
**Lifetime:** Indefinite

**Contains:**
- User preferences
- Common patterns across projects
- Debugging insights
- Verified solutions

**Management:**
- Only store verified, stable patterns
- Review periodically for accuracy
- Update when new patterns confirmed across multiple sessions

---

## Memory Operations

### STORE (Write to Memory)

**Trigger:** Milestone reached, decision made, learning discovered

**Process:**
1. Identify which layer the info belongs to
2. Check for conflicts with existing memory
3. Write in structured format (tables/key-value, NOT prose)
4. Verify accuracy before persisting

**Examples:**
- Session decision -> Layer 2 (story file)
- Key learning -> Layer 3 (CLAUDE.md)
- User preference -> Layer 4 (auto-memory)

---

### RETRIEVE (Load from Memory)

**Trigger:** Session start, task switch, question about past work

**Process:**
1. CLAUDE.md loads automatically (Layer 3 entry point)
2. Follow references to load task-specific context (Layer 2)
3. Load domain files only when needed (Layer 3 on-demand)
4. Check auto-memory for relevant patterns (Layer 4)

**Loading Priority:**
1. Current user query (always full)
2. System instructions (CLAUDE.md + core-rules.md)
3. Active task context (story file)
4. Recent history (last 5-10 turns)
5. Domain knowledge (as needed)
6. Workflow rules (when triggered)

---

### PRUNE (Clean Memory)

**Trigger:** Task completion, session end, periodic review

**Process:**
1. Archive completed stories (ACTIVE -> DONE)
2. Remove session-specific details from INDEX.md
3. Verify remaining memory is current and accurate
4. Move old session summaries to SESSION-LOG.md
5. Remove redundant or outdated information

**Pruning Schedule:**
- **Session end:** Prune verbose tool outputs
- **Task completion:** Archive story file
- **Monthly:** Review SESSION-LOG.md, keep last 6 months
- **Quarterly:** Review CLAUDE.md learnings for accuracy

---

### CONSOLIDATE (Compress Memory)

**Trigger:** Context window approaching limits

**Process:**
1. Summarize older conversation turns (Layer 1)
2. Clear verbose tool outputs, keep conclusions (Layer 1)
3. Extract key decisions into story notes (Layer 1 -> Layer 2)
4. After compaction, re-read story file to restore context

**What to Preserve:**
- Architectural decisions
- Unresolved bugs/issues
- Implementation details
- Error patterns

**What to Discard:**
- Redundant tool outputs
- Verbose command results (keep summaries)
- Exploratory dead-ends
- Temporary debugging context

---

## Memory Flow Between Layers

```
Session Memory --(extract key findings)--> Working Memory
     |                                          |
     |                                          |
     +---(compaction summaries)--> Session Memory (refreshed)
                                                |
Working Memory --(task complete, learnings)--> Project Memory
     |                                          |
     |                                          |
Project Memory --(loaded at session start)--> Session Memory
     |
     |
Project Memory --(cross-project patterns)--> Agent Identity Memory
```

---

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| **Memory Hoarding** | Loading everything into context | Use reference table, load on demand |
| **Narrative Memory** | Storing long prose descriptions | Use tables, key-value, checklists |
| **Stale Memory** | Outdated info never pruned | Add dates, review quarterly |
| **Duplicate Memory** | Same fact in multiple files | Single source of truth per fact |
| **Implicit Memory** | Assuming agent remembers across sessions | Always persist explicitly to files |
| **Unverified Memory** | Storing guesses or assumptions | Verify before persisting to Layer 3+ |

---

## Best Practices

### Do
- Structure everything (tables, key-value, YAML)
- Update story files at milestones
- Record decisions with rationale
- Prune after task completion
- Load only what's needed for current task
- Verify accuracy before persisting
- Monitor context window usage proactively
- End session before compaction threshold

### Don't
- Write long narrative prose
- Store credentials in context files
- Load everything "just in case"
- Keep outdated information
- Duplicate facts across files
- Assume agent remembers implicitly
- Ignore context window warnings
- Continue past Red zone without good reason

---

> **Context window monitoring:** See `.claude/rules/context-window-monitoring.md` (auto-loaded)
> **Enforcement checklists:** See `.claude/rules/context-enforcement.md` (auto-loaded)
