---
name: space-report
description: Health report of a LearnFloo space (members, activity, courses, lives, support, usage and costs) with concrete next actions. Use when the owner asks "how is my community doing", for a weekly or monthly review, or before a decision (pricing, new course, live cadence).
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server (https://api.learnfloo.com/mcp), read access is enough
---

# Space report

Read-only skill: it never writes. It works with a read-only grant.

## Ground rules
Follow the shared rules in `../_GROUND_RULES.md` (reply in the user's language, `get_space` first, paginate, dates in local time).

## Steps
1. `get_space` → name, counts, group vocabulary. `get_space_usage` → hours of live, plays, stored minutes since the last invoice, account state (billing active, live allowed, cap). Flag anything that blocks: billing inactive, live not allowed, cap reached.
2. Members: `list_users` (page through, 200 per page; stop at 1 000 and say so). Count by role and status; note suspended and expired.
3. Engagement: `get_leaderboard` (limit 20) for the most active; `list_challenges` and `list_badges` for what drives XP. `list_groups` then `get_group_stats` for the groups the user cares about (ask which ones when there are more than 5): course progress, posts, lives attended, XP over 30 days, video watch share (`videoPct`).
4. Feed: `list_posts` (limit 50). Count posts per category over the period, spot unanswered `question` posts (open them with `get_post` when the comment count is 0), and `wins` to celebrate.
5. Courses: `list_courses` with `includeUnpublished: true`. For the 3 most important published courses (ask if unclear) `get_course_progress` → started, completed, where learners drop.
6. Lives: `list_live_sessions` (status `ended`) for the period → `get_live_attendance` on each (attended, peak, average watch time). `list_live_sessions` with status `scheduled` for what is coming.
7. Support: `list_support_tickets` with `scope: "space"`, status `active` → open and pending counts, oldest waiting ticket.
8. Calendar: `list_events` from today, 30 days.

## Output
A report in this order, short sentences, numbers in a table, no jargon:
- **Headline**: one line, the single most important fact.
- **Numbers**: members (active / new / suspended), posts per week, lives held and average attendance, course completion, open tickets, usage vs cap.
- **What works**: 2-3 facts with evidence (which course, which live, who).
- **What needs attention**: unanswered questions, silent groups, learners stuck at the same lesson, tickets waiting, usage near the cap.
- **Next 3 actions**: concrete, each doable with another skill (`animate-community`, `follow-up-members`, `prepare-live`, `support-inbox`) or in the app. Offer to run one.

Do not invent trends: compare with a previous period only when the user gave you the previous report or the data covers both periods.
