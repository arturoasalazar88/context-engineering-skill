---
name: context-engineering
description: Context engineering system for AI coding agents — manage project context, stories, workflows, and token budgets across sessions
---

# Context Engineering Skill

A systematic approach to managing what information the AI agent sees and when, using tiered context loading, structured formats, and token budget management.

## Available Workflows

| Workflow | Description | When to Use |
|----------|-------------|-------------|
| `/context-init` | Initialize a project with context engineering structure | New project setup |
| `/context-start` | Load project context and select a story to work on | Every session start |
| `/context-ingest` | Add new context (stories, docs, rules, system info) | Adding new work items or knowledge |
| `/context-refactor` | Audit and refactor context to match best practices | Periodic maintenance |
| `/context-update` | Apply bug fixes and updates from the skill repo | When updates are available |
| `/context-close` | Save work, verify compliance, close session cleanly | Every session end |

## Key Resources

| Resource | Location | Purpose |
|----------|----------|---------|
| Templates | `templates/` | Template files for project initialization |
| Documentation | `docs/` | Comprehensive guides and references |
| Context Schema | `context/CONTEXT-SCHEMA.yaml` | Defines what loads when |
| Memory Protocol | `context/MEMORY-PROTOCOL.md` | Memory management guide |
| Rules | `.claude/rules/` | Auto-loaded agent rules |

## Core Principles

1. **Minimize Static Context** — Keep always-loaded content under 2,500 tokens
2. **Progressive Disclosure** — Load information in tiers, only when needed
3. **Structured Over Prose** — Tables, checklists, key-value pairs over narrative
4. **Single Source of Truth** — Each piece of information lives in exactly one place
5. **Credential Isolation** — Credentials only in `context/SYSTEM.md`

## Quick Reference

- Full guide: [docs/context-engineering-guide.md](docs/context-engineering-guide.md)
- Commands reference: [docs/commands-reference.md](docs/commands-reference.md)
- Rules reference: [docs/rules-reference.md](docs/rules-reference.md)
- Memory layers: [docs/memory-layers.md](docs/memory-layers.md)
