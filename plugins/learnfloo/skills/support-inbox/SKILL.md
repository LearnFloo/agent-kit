---
name: support-inbox
description: Triage and answer the support tickets of a LearnFloo space - open and pending tickets, priorities, drafted replies in the space's tone, status and assignment changes, recurring issues. Use when the owner or the team asks about support, tickets, member requests, or wants to clear the inbox.
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server, full access to reply (read access to triage only)
---

# Support inbox

Follow `../_GROUND_RULES.md`. A reply is shown in full and sent only on the user's go, one ticket at a time. A staff reply moves the ticket to `pending` automatically.

## 1. Load the inbox
`list_support_tickets` with `scope: "space"` and `status: "active"` (open and pending), limit 100. For each ticket to handle: `get_support_ticket` → messages (internal notes are never returned). Say how many are open, pending, and the oldest waiting time.

## 2. Triage
Rank by: urgent words (payment, cannot access, live in one hour), waiting time, member value (a teacher or a group leader first). Propose a priority per ticket (`low`, `normal`, `high`, `urgent`) and an assignee when the team has several people (ask for the e-mails once).

## 3. Answer
For each ticket, in order:
- Understand: what the person wants, what has been tried, what the space can do (check the facts with the read tools: `get_user` for their membership and progress, `get_course_progress` for a lesson issue, `get_live_session` or `get_live_replay` for a live issue, `get_space_usage` for a capacity issue).
- Draft: greet by first name, one paragraph that solves or asks the one missing detail, next step, sign-off. Match the space's tone (read two previous staff replies).
- Send: `reply_support_ticket` with `staff: {}` (the key creator) or `staff: { email }` for another team member, `content` plain text or `format: "html"`.
- Status: `set_support_ticket_status` with `staff`, `status` (`pending` after a question, `resolved` when solved), `priority`, `assigneeEmail` (`null` to unassign).

## 4. Recurring issues
After the pass, group the tickets by cause (access, payment, video, live, content) and propose one fix per cause: an FAQ post (`animate-community`), a lesson edit (`build-course`), a setting to change in the app. Offer to draft it.

## Never
- Never resolve a ticket the user did not read.
- Never promise a refund, a date or a feature: say the team will confirm.
- Never quote internal information (usage, billing state) to the member.
