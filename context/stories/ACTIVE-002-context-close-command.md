# Story 002: Add /context-close Command

<metadata>
  <id>002</id>
  <status>ACTIVE</status>
  <created>2026-02-15</created>
  <updated>2026-02-15</updated>
  <type>feature</type>
  <version>1.2.0</version>
</metadata>

## Objective

Create a `/context-close` command that ensures proper session cleanup, verifies context engineering compliance, checks for pending user approvals, and reports token savings from hybrid workflow usage.

## Background

After successful implementation and validation of BUG-001 (workflow tracking), we need a complementary command to properly close sessions. This ensures:
- All work is properly saved
- User approval workflow is followed
- Context engineering standards are maintained
- Token efficiency metrics are tracked
- Gemini memory is cleaned up

## Tasks

**Phase 1: Command Implementation**
- [x] Draft command specification (user provided)
- [x] Review and enhance specification
- [x] Create `commands/context-close.md` file
- [x] Add command to installer script
- [ ] Test in context-engineering-skill repo
- [ ] Verify all checks work correctly

**Phase 2: Integration**
- [x] Update README.md to include /context-close
- [x] Add to commands table in Quick Start
- [ ] Update CONTEXT-SCHEMA.yaml if needed
- [ ] Test with hybrid workflow enabled
- [ ] Test without hybrid workflow

**Phase 3: Feature Tracking**
- [x] Add to FIXES-MANIFEST.yaml as FEATURE-001
- [x] Update /context-update commands table for context-close
- [ ] Test update process for new command

**Phase 4: Validation**
- [ ] Test in triptaste/landing-page project
- [ ] Verify token savings calculation accuracy
- [ ] Test all compliance checks
- [ ] Validate Gemini memory cleanup
- [ ] Document in commands-reference.md

## Progress Log

| Date | Update |
|------|--------|
| 2026-02-15 | Story created. User provided comprehensive command spec. |
| 2026-02-15 | Command file created with enhancements: --quick flag, practical approval detection, integration points table. |
| 2026-02-15 | FIXES-MANIFEST.yaml updated with FEATURE-001. README, install.sh, /context-update updated. |

## Decisions Made

1. **Command name**: `/context-close` (clear and consistent with /context-start)
2. **Scope**: Session cleanup + compliance verification + metrics reporting
3. **Token savings**: Use estimated values based on typical patterns (documented as estimates)
4. **Gemini cleanup**: Mandatory if Gemini CLI used (ephemeral context only)
5. **Feature tracking**: Add features to FIXES-MANIFEST.yaml (not just bugs)

## Technical Details

**Key Components:**

1. **Unsaved Work Check**
   - Git status analysis
   - Active story detection
   - Uncommitted changes report

2. **User Approval Verification**
   - Scans conversation for work completions
   - Checks for explicit approval phrases
   - Flags violations of user-approval.md workflow

3. **Compliance Verification**
   - Static context budget (target: <250 lines)
   - Credential leak detection
   - Story file update verification
   - File placement validation

4. **Token Savings Calculation**
   - Detects hybrid workflow enablement
   - Counts Gemini CLI invocations by type
   - Estimates savings per invocation type:
     - Code generation: ~500 tokens
     - Web fetch: ~300 tokens
     - Script generation: ~800 tokens
     - Command execution: ~200 tokens

5. **Session Statistics**
   - Duration tracking
   - Context window usage
   - Files modified count
   - Story progress summary

6. **Cleanup Recommendations**
   - Required actions (must do)
   - Optional actions (nice to have)
   - Readiness checklist

7. **Gemini Memory Cleanup**
   - Clear ephemeral session memory
   - Verification command provided

## Token Savings Estimates (Rationale)

Based on analysis of typical usage patterns:

| Activity | Claude Tokens | Gemini Delegation | Savings | Basis |
|----------|---------------|-------------------|---------|-------|
| Code generation | ~550 | ~50 (result only) | 500 | Claude generates vs receives |
| Web fetch/docs | ~330 | ~30 (summary only) | 300 | Fetch + process vs summary |
| Script generation | ~850 | ~50 (script only) | 800 | Full generation offloaded |
| Command execution | ~250 | ~50 (results only) | 200 | Execution + analysis vs results |

These are **estimates** and will be refined based on real usage data.

## Blockers

None currently.

## Context Engineering Compliance

- [x] Story file uses structured format (checklists, tables, YAML)
- [x] No credentials in story file
- [x] Acceptance criteria are clear and measurable
- [x] Memory layer identified: Project (new command affects all projects)
- [x] New files follow CONTEXT-SCHEMA.yaml placement rules
- [x] Token budget impact assessed (command adds ~300 lines = ~3,000 tokens)

## Acceptance Criteria

- [ ] `/context-close` command exists in commands/ directory
- [ ] All 8 steps execute correctly
- [ ] Git status check works
- [ ] User approval check detects violations
- [ ] Compliance checks verify all standards
- [ ] Token savings calculation works with hybrid workflow enabled
- [ ] Token savings report shows "NOT ENABLED" when hybrid workflow absent
- [ ] Gemini memory cleanup command provided when applicable
- [ ] Session statistics are accurate
- [ ] Final report is comprehensive and actionable
- [ ] Command integrated into installer (install.sh)
- [ ] README.md updated with new command
- [ ] Tracked in FIXES-MANIFEST.yaml as FEATURE-001
- [ ] /context-update can install it in existing projects
- [ ] Tested in at least 2 projects (skill repo + landing-page)

## Outcome

To be determined after implementation and testing.

## Related Files

- `commands/context-close.md` (to be created)
- `FIXES-MANIFEST.yaml` (to be updated with FEATURE-001)
- `README.md` (to be updated)
- `install.sh` (already handles new commands)
- `context/workflows/user-approval.md` (referenced)
- `context/workflows/hybrid-workflow.md` (referenced)
- `context/workflows/gemini-cli.md` (referenced)

## Testing Plan

**Test Case 1: Clean Session**
- No uncommitted changes
- All work approved
- All compliant
- Expected: "READY TO CLOSE"

**Test Case 2: Pending Approval**
- Work completed but not approved
- Expected: Warning + recommendations

**Test Case 3: Compliance Violations**
- CLAUDE.md over 250 lines
- Expected: Violation report with remediation

**Test Case 4: Hybrid Workflow Active**
- Multiple Gemini CLI calls made
- Expected: Token savings report with breakdown

**Test Case 5: No Hybrid Workflow**
- Standard Claude-only session
- Expected: "NOT ENABLED" message with setup instructions

**Test Case 6: Credential Leak**
- API key in CLAUDE.md (simulated)
- Expected: Security violation flagged
