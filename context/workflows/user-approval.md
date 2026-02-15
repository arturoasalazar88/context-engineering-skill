# User Approval Protocol

> Load BEFORE marking any task or bug as resolved

---

## Protocol

1. **Present summary of work completed**
   - What was changed
   - What files were modified
   - What the outcome is

2. **Show evidence**
   - Test results (if applicable)
   - File changes made
   - Command outputs
   - Verification steps taken

3. **Wait for explicit user approval**
   - "yes"
   - "approved"
   - "looks good"
   - Any clear confirmation

4. **Only then mark as resolved**
   - Update story status to DONE
   - Move story file (ACTIVE -> DONE)
   - Update INDEX.md

---

## Why This Exists

Prevents the agent from closing tasks prematurely. Users maintain full control over what is considered "done."

---

## Example

```
Agent: "I've completed Story 003 - Add rate limiting to API.

Summary:
- Added rate-limit middleware using express-rate-limit
- Configured 100 requests per 15 minutes per IP
- Added tests covering rate limit behavior
- Updated API documentation

Evidence:
- Tests passing: All 47 tests pass
- Files modified: src/middleware/rate-limit.js, src/app.js, tests/rate-limit.test.js
- Manual test: curl shows 429 after 100 requests

May I mark Story 003 as resolved?"

User: "Yes, looks good!"

Agent: [Updates story status to DONE]
```
