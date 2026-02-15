# Context Window Monitoring

> Prevent compaction by monitoring usage and ending sessions proactively

---

## Token Usage Thresholds

| Zone | Tokens | Status | Action |
|------|--------|--------|--------|
| Green | 0-100K | Safe | Normal work |
| Yellow | 100K-140K | Caution | Monitor, avoid large tasks |
| Red | 140K-160K | High | End session soon |
| Critical | 160K+ | Critical | Compaction imminent |

---

## When to Report

- **Session start** - Always report current usage and zone
- **After stories/tasks** - Report if Yellow zone (100K+) or above
- **Before large tasks** - Check capacity, warn if Red zone (140K+)
- **Session end** - Report final usage

---

## Warning Format

**Yellow (100K-140K):** "Context window at XX% (XXK/200K). Consider wrapping up long tasks."

**Red (140K-160K):** "Context window at XX% (XXK/200K). RECOMMEND ending session soon."

**Critical (160K+):** "Context window at XX% (XXK/200K). End session immediately."

---

> **Detailed guidance:** `context/MEMORY-PROTOCOL.md` - Context Window Management
