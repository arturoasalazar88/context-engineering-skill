# Memory Layers

The 4-layer memory architecture that underpins context engineering.

---

## Overview

AI coding agents don't have persistent memory by default. Everything exists in the context window and disappears when the session ends. Context engineering solves this with a 4-layer system that persists information at different scopes and lifetimes.

```
Layer 4: Identity Memory    (permanent, cross-project)
    |
Layer 3: Project Memory     (persistent, cross-session)
    |
Layer 2: Working Memory     (task-scoped, survives sessions)
    |
Layer 1: Session Memory     (ephemeral, current conversation)
```

---

## Layer 1: Session Memory (Ephemeral)

| Attribute | Value |
|-----------|-------|
| **Scope** | Current conversation only |
| **Storage** | Context window (tokens) |
| **Lifetime** | Until compaction or session end |
| **Capacity** | 200,000 tokens (shared with everything else) |

**Contains:**
- Recent messages (last 5-10 turns)
- Active tool results (temporary)
- Current decision state
- Working context for active task

**Management:**
- Keep last 5-10 message turns in full
- Clear tool outputs after processing (keep conclusions only)
- Summarize older turns when approaching limits
- Monitor usage with zone system (Green/Yellow/Red/Critical)

**Key risk:** Compaction. When the context window fills up, older messages are compressed or removed. This is why important information must be persisted to Layer 2 or 3.

---

## Layer 2: Working Memory (Task-Scoped)

| Attribute | Value |
|-----------|-------|
| **Scope** | Current story or bug |
| **Storage** | Story files (`context/stories/ACTIVE-*.md`) |
| **Lifetime** | Duration of the task |
| **Capacity** | ~1,500 tokens per story file |

**Contains:**
- Objective (what we're trying to accomplish)
- Task checklist (with completion status)
- Progress log (dated updates)
- Decisions made (with rationale)
- Blockers (what's preventing progress)
- Next steps

**Management:**
- Update at each milestone (not every small step)
- Record decisions with rationale (the "why", not just "what")
- Structure as checklists for quick scanning
- Survives session end, compaction, and context resets

**Why it matters:** When a session ends or gets compacted, working memory is the first thing the agent reads to restore context. Well-maintained story files let the agent pick up exactly where it left off.

---

## Layer 3: Project Memory (Persistent)

| Attribute | Value |
|-----------|-------|
| **Scope** | Entire project, cross-session |
| **Storage** | CLAUDE.md + context/*.md files |
| **Lifetime** | Duration of the project |
| **Capacity** | ~2,500 tokens always-loaded + ~10,000 on-demand |

**Contains:**
- Project architecture and structure
- Server and deployment information
- Key learnings (verified patterns and gotchas)
- Conventions and coding patterns
- Configuration schemas
- Troubleshooting guides

**Management:**
- CLAUDE.md = entry point (always loaded, <150 lines)
- Context files = domain knowledge (loaded on demand)
- Update learnings after significant sessions
- Prune outdated information quarterly
- Structure as tables/key-value, NOT prose

**Key insight:** CLAUDE.md is a routing table, not a knowledge base. It tells the agent where to find information, not what the information is.

---

## Layer 4: Identity Memory (Permanent)

| Attribute | Value |
|-----------|-------|
| **Scope** | Cross-project, agent-level |
| **Storage** | `~/.claude/projects/*/memory/MEMORY.md` |
| **Lifetime** | Indefinite |
| **Capacity** | ~200 lines per project |

**Contains:**
- User preferences (workflow, communication style)
- Common patterns across projects
- Debugging insights that apply broadly
- Verified solutions to recurring problems

**Management:**
- Only store verified, stable patterns (not guesses)
- Review periodically for accuracy
- Update when patterns confirmed across multiple sessions
- Keep concise (200 lines max)

---

## Memory Operations

### STORE (Write to Memory)

**Trigger:** Milestone reached, decision made, learning discovered

| Information Type | Target Layer | Example |
|-----------------|-------------|---------|
| Session decision | Layer 2 (story file) | "Chose JWT over sessions for auth" |
| Key learning | Layer 3 (CLAUDE.md) | "npm package renamed from X to Y" |
| User preference | Layer 4 (agent memory) | "User prefers detailed plans" |

**Rules:**
1. Identify which layer the info belongs to
2. Check for conflicts with existing memory
3. Write in structured format (tables/key-value, NOT prose)
4. Verify accuracy before persisting

### RETRIEVE (Load from Memory)

**Trigger:** Session start, task switch, question about past work

**Loading priority:**
1. Current user query (always full)
2. System instructions (CLAUDE.md + core-rules.md) - Layer 3
3. Active task context (story file) - Layer 2
4. Recent history (last 5-10 turns) - Layer 1
5. Domain knowledge (as needed) - Layer 3
6. Workflow rules (when triggered) - Layer 3

### PRUNE (Clean Memory)

**Trigger:** Task completion, session end, periodic review

| Schedule | Action |
|----------|--------|
| Session end | Clear verbose tool outputs from Layer 1 |
| Task completion | Archive story (ACTIVE -> DONE) in Layer 2 |
| Monthly | Review SESSION-LOG.md, keep last 6 months |
| Quarterly | Review CLAUDE.md learnings for accuracy |

### CONSOLIDATE (Compress Memory)

**Trigger:** Context window approaching limits

**Process:**
1. Summarize older conversation turns (Layer 1)
2. Clear verbose tool outputs, keep conclusions (Layer 1)
3. Extract key decisions into story notes (Layer 1 -> Layer 2)
4. After compaction, re-read story file to restore context

---

## Memory Flow Between Layers

```
Layer 1 (Session)
  |
  |-- extract key findings --> Layer 2 (Working/Story)
  |-- compaction summaries --> Layer 1 (refreshed)
  |
Layer 2 (Working)
  |
  |-- task complete, learnings --> Layer 3 (Project)
  |
Layer 3 (Project)
  |
  |-- loaded at session start --> Layer 1 (Session)
  |-- cross-project patterns --> Layer 4 (Identity)
  |
Layer 4 (Identity)
  |
  |-- loaded at session start --> Layer 1 (Session)
```

**Practical example:**
1. During work, you discover "Docker needs `--platform linux/arm64` on this server" (Layer 1)
2. You record it in the story progress log (Layer 2)
3. After the task, you add it to CLAUDE.md Key Learnings (Layer 3)
4. If you see this pattern in other projects, you add it to agent memory (Layer 4)

---

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| **Memory Hoarding** | Loading all context into Layer 1 | Use reference tables, load on demand |
| **Narrative Memory** | Storing long prose descriptions | Use tables, key-value, checklists |
| **Stale Memory** | Outdated info never cleaned up | Add dates, review quarterly |
| **Duplicate Memory** | Same fact in multiple layers | Single source of truth per fact |
| **Implicit Memory** | Assuming agent remembers across sessions | Always persist to Layer 2+ |
| **Unverified Memory** | Storing guesses as facts | Verify before persisting to Layer 3+ |

---

## Further Reading

- [Context Engineering Guide](context-engineering-guide.md) - Full principles
- [Rules Reference](rules-reference.md) - Default and optional rules
- [Commands Reference](commands-reference.md) - How to use the slash commands
