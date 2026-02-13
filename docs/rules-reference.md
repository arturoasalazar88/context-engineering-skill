# Rules Reference

Complete catalog of default and optional rules used by the context engineering system.

---

## How Rules Work in Claude Code

Rules are markdown files that Claude Code loads automatically or on demand:

| Location | Loading | Purpose |
|----------|---------|---------|
| `.claude/rules/*.md` | **Auto-loaded** every session | Mandatory rules, always active |
| `context/workflows/*.md` | **On-demand**, loaded when triggered | Situation-specific rules |

**Important:** Every file in `.claude/rules/` increases the always-loaded token budget. Only put rules there that truly apply to every session. Everything else goes in `context/workflows/`.

---

## Default Rules (Always Installed)

These three rule files are created by `/context-init` and are always active.

### 1. core-rules.md (~30 lines, ~300 tokens)

**Location:** `.claude/rules/core-rules.md`

**Contains 7 mandatory rules:**

| # | Rule | Why It Exists |
|---|------|--------------|
| 1 | **NEVER mark tasks resolved without explicit user approval** | Prevents premature closure of work items. The agent must present evidence and get a "yes" before marking anything done. |
| 2 | **ALWAYS present summary + evidence before requesting resolution** | Forces the agent to show its work, making it easy for the user to verify before approving. |
| 3 | **ALWAYS load stories/INDEX.md at session start** | Ensures the agent knows what work exists before starting. Prevents duplicate work or missed context. |
| 4 | **NEVER store secrets in CLAUDE.md or context files** | Credentials in frequently-loaded files risk exposure. SYSTEM.md is the only approved location. |
| 5 | **ALWAYS update story files at task milestones** | Ensures progress is persisted to files so it survives session boundaries and compaction. |
| 6 | **ALWAYS follow context engineering principles** | References the enforcement checklist to maintain structured, efficient context. |
| 7 | **MONITOR context window usage** | Prevents compaction by tracking token usage and ending sessions proactively. |

**Also contains:** Trigger references for loading on-demand workflow rules.

### 2. context-enforcement.md (~80 lines, ~800 tokens)

**Location:** `.claude/rules/context-enforcement.md`

**Contains session checklists for:**

**Session Start:**
- Verify CLAUDE.md is under 150 lines
- Verify .claude/rules/ contains only essential files
- Load stories/INDEX.md

**Before Creating New Files:**
- Check CONTEXT-SCHEMA.yaml for proper location
- Ensure structured format (not prose)
- Verify no credentials in content
- Confirm file doesn't belong in always-loaded context

**Before Adding Context:**
- Is this needed for current task?
- Can this be referenced instead of loaded?
- Does this fit token budget?

**Before Creating Stories:**
- Follow story template
- Use structured format
- Specify acceptance criteria
- Identify memory layer
- Include compliance section

**Session End:**
- Review for credential leaks
- Verify static context unchanged
- Update story files with progress

**Monthly Checks:**
- CLAUDE.md under 150 lines?
- Token budget compliance?
- Credentials only in SYSTEM.md?
- Workflow rules on-demand (not auto-loaded)?

**Security Rules:**
- NEVER store credentials in: CLAUDE.md, INDEX.md, story files, rule files
- ONLY in: context/SYSTEM.md

### 3. context-window-monitoring.md (~37 lines, ~370 tokens)

**Location:** `.claude/rules/context-window-monitoring.md`

**Token Usage Zones:**

| Zone | Tokens | Status | Action |
|------|--------|--------|--------|
| Green | 0-100K | Safe | Normal work |
| Yellow | 100K-140K | Caution | Monitor, avoid large tasks |
| Red | 140K-160K | High | End session soon |
| Critical | 160K+ | Critical | End immediately |

**When to Report:**
- Session start (always)
- After completing stories/tasks (if Yellow+)
- Before large tasks (warn if Red+)
- Session end (always)

**Warning Formats:**
- Yellow: "Context window at XX% (XXK/200K). Consider wrapping up long tasks."
- Red: "Context window at XX% (XXK/200K). RECOMMEND ending session soon."
- Critical: "Context window at XX% (XXK/200K). End session immediately."

---

## Default Workflow Rules

### user-approval.md

**Location:** `context/workflows/user-approval.md`
**Created by:** `/context-init`
**Loaded when:** Before marking any task or bug as resolved

**Protocol:**
1. Present summary of work completed
2. Show evidence (test results, file changes, command outputs)
3. Wait for explicit user approval ("yes", "approved", "looks good")
4. Only then update story status to DONE

**Why:** Prevents the agent from closing tasks prematurely. Users maintain full control over what is considered "done."

---

## Optional Rules

Optional rules are NOT created by default. Add them using `/context-ingest` when needed.

### Creating a Custom Always-Loaded Rule

**When:** The rule applies to literally every session, regardless of task.

```bash
# File: .claude/rules/my-rule.md
```

```markdown
# My Custom Rule

> Short description of what this rule enforces

## Rules

1. **Rule statement** - explanation
2. **Rule statement** - explanation

## When to Apply

- Always / specific conditions
```

**Token budget impact:** Every line added to `.claude/rules/` increases the always-loaded budget. Target: total rules < 150 lines.

### Creating a Custom Workflow Rule

**When:** The rule applies only in specific situations.

```bash
# File: context/workflows/my-workflow.md
```

```markdown
# My Workflow

> Loaded when: [describe trigger condition]

## Steps

1. Step one
2. Step two
3. Step three

## Checklist

- [ ] Item 1
- [ ] Item 2
```

**Token budget impact:** Zero on always-loaded budget. Only loaded when triggered.

### Example Optional Rules

| Rule | Location | Trigger |
|------|----------|---------|
| Code review checklist | `context/workflows/code-review.md` | Before submitting PR |
| Deployment procedure | `context/workflows/deployment.md` | Before deploying |
| Testing standards | `context/workflows/testing.md` | Before writing tests |
| Database migration | `context/workflows/migrations.md` | Before modifying schema |
| Security checklist | `context/workflows/security.md` | Before handling auth/crypto |

---

## Rules Architecture

```
Always-loaded (.claude/rules/)           On-demand (context/workflows/)
  |                                        |
  |-- core-rules.md (~300 tokens)          |-- user-approval.md
  |-- context-enforcement.md (~800 tokens) |-- [custom-workflow-1].md
  |-- context-window-monitoring.md (~370)  |-- [custom-workflow-2].md
  |                                        |-- [custom-workflow-3].md
  |                                        |
  Total: ~1,470 tokens (auto)             Total: 0 tokens (until loaded)
```

**Decision guide for rule placement:**

```
Does the rule apply to EVERY session?
  YES -> .claude/rules/ (auto-loaded)
    BUT: Will it push total rules over 150 lines?
      YES -> Reconsider. Can it be on-demand?
      NO  -> Add it
  NO  -> context/workflows/ (on-demand)
```

---

## Token Budget Summary

| Component | Lines | Tokens | Status |
|-----------|-------|--------|--------|
| core-rules.md | ~30 | ~300 | Default |
| context-enforcement.md | ~80 | ~800 | Default |
| context-window-monitoring.md | ~37 | ~370 | Default |
| **Total default rules** | **~147** | **~1,470** | **Within budget** |
| Target maximum | 150 | 1,500 | - |
| Remaining capacity | ~3 lines | ~30 tokens | - |

**Note:** The rules are intentionally near the 150-line target. Adding custom always-loaded rules requires careful consideration. Prefer workflow rules in `context/workflows/` whenever possible.
