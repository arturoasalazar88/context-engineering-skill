# Context Engineering Guide

A comprehensive guide to the principles and practices behind context engineering for AI coding agents.

---

## Why Context Engineering Matters

AI coding agents (like Claude Code) have a fixed context window - typically 200,000 tokens. Everything the agent sees - system prompts, CLAUDE.md, rule files, conversation history, tool outputs - competes for this limited space.

**The problem:** Without discipline, context files grow organically until they consume most of the window. This leads to:
- Slower responses (more tokens to process)
- Context compaction (agent loses early conversation history)
- Lower quality (important info buried in noise)
- Session limits (can't work on complex tasks before hitting limits)

**The solution:** Context engineering - a systematic approach to managing what information the agent sees and when.

**Real-world result:** Applying these principles to a production project reduced always-loaded context from 33,000 tokens to 2,000 tokens (94% reduction) while improving agent effectiveness.

---

## Core Principles

### 1. Minimize Static Context

Static context is everything that loads automatically every session. Keep it minimal.

| What | Target | Why |
|------|--------|-----|
| CLAUDE.md | <150 lines (~1,500 tokens) | Loaded every turn |
| .claude/rules/*.md | <100 lines (~1,000 tokens) | Loaded every turn |
| **Total static** | **<250 lines (~2,500 tokens)** | **Leaves room for actual work** |

**How:** Use CLAUDE.md as a routing table (references to other files), not a knowledge base.

### 2. Progressive Disclosure

Load information in tiers, only when needed:

```
Always loaded (every session):
  CLAUDE.md + rules = ~2,500 tokens

Session start (agent reads on request):
  stories/INDEX.md = ~1,000 tokens

Per-task (when working on specific task):
  Active story file = ~1,500 tokens

On-demand (when specific need arises):
  Workflow rules, domain files = ~5,000 tokens

Archive (historical reference only):
  Completed stories, session logs = ~2,000 tokens
```

**How:** Reference files in tables with "Load When" conditions instead of including their content.

### 3. Structured Over Prose

AI agents process structured data more efficiently than narrative prose.

**Instead of:**
> The project uses Docker Compose v2 for container management. The bot runs on an Orange Pi 5 at IP 10.1.0.104 with user rdpuser. The monitoring stack is on a separate Orange Pi 3B at 10.1.0.106.

**Use:**
| Server | IP | User | Purpose |
|--------|-----|------|---------|
| Orange Pi 5 | 10.1.0.104 | rdpuser | Bot runtime |
| Orange Pi 3B | 10.1.0.106 | triptaste | Monitoring |

**Preferred formats (most to least efficient):**
1. Tables (best for multi-field data)
2. Key-value pairs (best for attributes)
3. Checklists (best for tasks and verification)
4. YAML/JSON (best for schemas)
5. Prose (avoid - use only for explanations that don't fit other formats)

### 4. Single Source of Truth

Each piece of information lives in exactly one place.

| Information | Lives In | NOT In |
|-------------|----------|--------|
| Active tasks | context/stories/INDEX.md | CLAUDE.md |
| Server details | context/SYSTEM.md | CLAUDE.md, story files |
| Credentials | context/SYSTEM.md | Anywhere else |
| Workflow rules | context/workflows/ | .claude/rules/ (unless always needed) |
| Architecture | context/ARCHITECTURE.md | CLAUDE.md, story files |

**CLAUDE.md references these files** with a table showing when to load each one.

### 5. Credential Isolation

Credentials go in exactly one file: `context/SYSTEM.md`

**NEVER store credentials in:**
- CLAUDE.md
- .claude/rules/*.md
- context/stories/*.md
- Any file that might be loaded frequently

**Why:** Frequently loaded files expose credentials in the context window where they could leak through tool outputs or conversation.

---

## File Organization

### Directory Structure

```
project-root/
  CLAUDE.md                    # Entry point - routing table to everything else
  .claude/
    rules/                     # Auto-loaded rules (keep minimal)
      core-rules.md            # Mandatory agent rules
      context-enforcement.md   # Session checklists
      context-window-monitoring.md  # Token usage monitoring
    commands/                  # Slash commands (not auto-loaded)
      context-init.md
      context-ingest.md
      context-start.md
  context/                     # Domain knowledge (loaded on demand)
    CONTEXT-SCHEMA.yaml        # Defines what loads when
    MEMORY-PROTOCOL.md         # Memory management guide
    SYSTEM.md                  # Servers & credentials (sensitive)
    stories/                   # Task tracking
      INDEX.md                 # Master index of all stories
      ACTIVE-*.md              # In-progress work
      DONE-*.md                # Completed work
      BACKLOG-*.md             # Planned work
      BLOCKED-*.md             # Blocked work
      SESSION-LOG.md           # Historical session summaries
    workflows/                 # Process rules (loaded on demand)
      user-approval.md         # Task resolution protocol
```

### File Placement Decision Tree

```
New content to add:

1. Is it a task/feature/bug?
   -> context/stories/[STATUS]-XXX-[slug].md

2. Is it a rule that applies to EVERY session?
   -> .claude/rules/[name].md (WARNING: increases static budget)

3. Is it a workflow/process for specific situations?
   -> context/workflows/[name].md

4. Is it server/credential information?
   -> context/SYSTEM.md (ONLY here)

5. Is it domain knowledge (architecture, API, config)?
   -> context/[DOMAIN].md

6. Is it a general project update?
   -> Update relevant section in CLAUDE.md
```

---

## Token Budget Management

### Budget Targets

| Category | Target | Maximum |
|----------|--------|---------|
| Always-loaded (CLAUDE.md + rules) | 2,000 tokens | 2,500 tokens |
| Session start (INDEX.md) | 1,000 tokens | 1,500 tokens |
| Per-task (story + context) | 3,000 tokens | 4,000 tokens |
| On-demand (workflows, domain) | 5,000 tokens | 8,000 tokens |
| **Total managed context** | **11,000 tokens** | **16,000 tokens** |

### Estimating Tokens

Quick estimation: **1 line ~ 10 tokens**

| Lines | Estimated Tokens |
|-------|-----------------|
| 50 | ~500 |
| 100 | ~1,000 |
| 150 | ~1,500 |
| 250 | ~2,500 |

### Context Window Zones

| Zone | Tokens Used | Action |
|------|------------|--------|
| Green | 0-100K | Normal work |
| Yellow | 100K-140K | Monitor, avoid starting large tasks |
| Red | 140K-160K | End session soon |
| Critical | 160K+ | End session immediately |

---

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|-------------|---------|----------|
| **Memory Hoarding** | Loading all context "just in case" | Use reference tables, load on demand |
| **Narrative Memory** | Storing long prose descriptions | Use tables, key-value, checklists |
| **Stale Memory** | Outdated info never cleaned up | Add dates, review quarterly |
| **Duplicate Memory** | Same fact in multiple files | Single source of truth per fact |
| **Implicit Memory** | Assuming agent remembers across sessions | Always persist to files explicitly |
| **Unverified Memory** | Storing guesses as facts | Verify before persisting |
| **Credential Scatter** | Secrets in multiple files | ONLY in context/SYSTEM.md |
| **Rule Bloat** | Too many always-loaded rules | Move specific rules to workflows/ |

---

## Best Practices Summary

### Do

- Keep CLAUDE.md under 150 lines
- Use tables for multi-field data
- Load context progressively (tier by tier)
- Put credentials only in SYSTEM.md
- Track work through stories with checklists
- Monitor context window usage
- Update story files at milestones
- Record decisions with rationale
- Prune after task completion
- End sessions before Red zone

### Don't

- Write long narrative prose in context files
- Load everything at session start
- Store credentials outside SYSTEM.md
- Keep outdated information
- Duplicate facts across files
- Assume the agent remembers between sessions
- Ignore context window warnings
- Add rules to .claude/rules/ unless truly needed every session

---

## Further Reading

- [Commands Reference](commands-reference.md) - How to use the slash commands
- [Rules Reference](rules-reference.md) - Default and optional rules
- [Memory Layers](memory-layers.md) - 4-layer memory architecture
