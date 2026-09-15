---
name: learnfloo-integration
description: Integrate an external platform (LMS, website, CRM, app) with LearnFloo through the API and MCP - external user ids, single sign-on entry URLs into the space and into lives, groups synced from classes, XP and lesson completion from your side, webhooks, API keys and OAuth grants, rate limits. Use for developer questions about the LearnFloo API, MCP server, SSO, webhooks or a migration.
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server for live checks; the REST reference at https://api.learnfloo.com/docs
---

# LearnFloo integration

Follow `../_GROUND_RULES.md`. This skill answers developer questions and runs checks with the read tools; it creates test data only on the user's go.

## The model in five points
1. **One key or grant = one space.** `get_space` tells which. A platform with several spaces uses one key per space.
2. **Your users** are created with `create_user` (`externalId`, `name`, optional `role`; `member: false` creates the account without joining the space), idempotent on `externalId`; everywhere else they are addressed as `ext:<externalId>`. Members with a LearnFloo account are addressed by id or `{ email }`.
3. **Sign-in without a password**: `create_user_entry_url` (space) and `create_live_entry_url` (live, viewer or speaker) return a single-use URL valid 15 minutes. Generate it server-side at click time; never store it.
4. **Writes carry an author**: `author: { externalId, name }` or `{ email }`; default the key creator. Read-only grants get `403` on writes.
5. **Rate limit** per key, cost per route (`X-RateLimit-*` headers, `get_space_usage.rateLimit`); `get_course_progress` costs 5. Page with `limit` and `cursor`.

## Common jobs
- **Sync classes**: `create_group` per class (manual), `set_user_groups` per user (replaces the list, idempotent), or `add_group_members` (500 per call). Content addressed with `groups` is seen by those members only.
- **Push learning results**: `award_xp` (with `refId` for idempotence), `complete_lesson` (XP, quests, badges and webhook fire as in the app), `report_live_conversion` during a live.
- **Read results**: `get_user_progress`, `get_user_xp`, `get_user_badges`, `get_course_progress`, `get_live_attendance`, `get_group_stats`.
- **Embed a live in your pages**: `create_live_session` → `hostUrl` for the host; viewers through `create_live_entry_url`; `get_live_replay` → MP4, HLS, embed URLs after the live.
- **Receive events**: `create_webhook` with an https URL and `events` (or `["*"]`); the signing secret is returned once. Check with `test_webhook` and `list_webhook_deliveries` (30 days). Event names are listed in the reference (`live.session.ended`, `live.replay.ready`, `video.lead`, …).
- **Files**: attachments and uploads go through the REST route `POST /api/v1/attachments` (not MCP); `add_media` accepts https URLs only.

## Connecting an AI assistant
- OAuth (recommended): the assistant opens the LearnFloo consent page; the user picks the space, the access level (read or full) and the open tools. Claude Code: `claude mcp add --transport http learnfloo https://api.learnfloo.com/mcp` then `/mcp`. Codex: `codex mcp add learnfloo --url https://api.learnfloo.com/mcp` then `codex mcp login learnfloo`.
- API key: header `Authorization: Bearer lf_live_…`, or `?key=` for clients without headers (visible in logs: create a dedicated key, revoke on doubt).
- Keys and grants, access level and open tools: Space settings → API and MCP.

## Debug checklist
`Error 401` → key or token missing or revoked. `Error 403` → read-only grant, closed tool, or role too low for the author. `Error 404` → wrong id, or the item belongs to another space. `Error 429` → rate limit, read `Retry-After`. `Error 400` → the message names the field; check the reference.
