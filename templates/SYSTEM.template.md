# System Information & Credentials

<metadata>
  <last_updated>{{DATE}}</last_updated>
  <status>template</status>
</metadata>

> **WARNING:** This file contains sensitive information. Load on demand only.
> **NEVER** copy credentials to CLAUDE.md, story files, or rule files.

---

## Servers

<!-- Add your servers below. Copy this block for each server. -->

### Server: {{SERVER_NAME}}

| Attribute | Value |
|-----------|-------|
| Device | {{SERVER_DEVICE}} |
| IP | {{SERVER_IP}} |
| User | {{SERVER_USER}} |
| SSH | `ssh {{SERVER_USER}}@{{SERVER_IP}}` |
| Path | {{DEPLOY_PATH}} |
| Key services | {{KEY_SERVICES}} |

---

## Credentials

**Store secrets in .env files or secret managers, NEVER in config files or git.**

<!-- List credential references below. Do NOT put actual passwords here
     unless this file is in .gitignore -->

| Service | Type | Location |
|---------|------|----------|
| Example | API Key | `.env` file on server |

---

## Network Access

<!-- Document network topology, VPN requirements, firewall rules if relevant -->

---

## Current State

<!-- Updated after each deployment -->

| Service | Status | Version | Last Deploy |
|---------|--------|---------|-------------|
