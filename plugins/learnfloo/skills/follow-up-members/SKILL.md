---
name: follow-up-members
description: Follow up the members of a LearnFloo space - inactive members, learners stuck in a course, newcomers without a first action, group by group, with a ranked list and suggested actions (post, XP, group, badge, challenge). Use when the owner asks who to re-engage, wants a retention review, or manages a class, a cohort or a team.
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server, read access for the review, full access for XP and group changes
---

# Follow up members

Follow `../_GROUND_RULES.md`. The review is read-only. Changes (`award_xp`, `add_group_members`, `set_user_groups`, `update_user`) are proposed one at a time. There is no e-mail or direct-message tool in MCP: re-engagement messages are posted in the feed (`create_post`, addressed to a group) or sent by the owner from the app; say it plainly.

## 1. Scope
Ask which population: the whole space, one group (class, cohort, team: `list_groups`, use the space's group words), one course (`list_courses`), or a challenge (`list_challenges`).

## 2. Collect
- Group: `get_group_stats` → per member: course progress, lessons completed, posts, lives attended, XP over 30 days, `videoPct`. This is the richest single call; prefer it.
- Whole space: `list_users` (page through) with role and status, XP and level; `get_leaderboard` for the active head. For a shortlist of members (10 at most) `get_user` → stats (lessons, lives, posts, badges) and `get_user_xp` → latest XP events with dates (the last event date is the best "last activity" signal).
- Course: `get_course_progress` → each learner's percentage; with `externalId` or `userId`, the lesson where they stopped.
- Challenge: `get_challenge` → participants and progress.

## 3. Segment and rank
Build four lists, each with name, evidence, suggested action:
1. **Silent newcomers**: joined recently, 0 lessons, 0 posts → welcome post naming them, a first easy lesson, a "present yourself" question.
2. **Stalled learners**: progress > 0 and no XP event for 14 days (or the window the user sets) → a nudge post in their group, a live Q&A on the lesson where most of them stopped (`prepare-live`).
3. **Falling actives**: were in the leaderboard head, low XP over 30 days → a personal note by the owner, a challenge.
4. **Champions**: top XP, many posts → thank them publicly, `award_xp` for help given, group leader role (`add_group_members` with role leader), speaker seat at the next live.

Show the lists as short tables (name, last activity, progress, action). Keep suspended and expired members apart (`status`).

## 4. Act, on the go
- `award_xp` with a clear `reason` (60 chars) and a `refId` so it is idempotent.
- `add_group_members` to move people into a follow-up group; `create_group` (manual, or automatic with a rule: `level_min`, `streak_days`, `challenge_joined`, `challenge_completed`, `badge`, `course_completed`) when the owner wants the segment to maintain itself.
- `create_post` addressed to the group (`groups`) with the drafted message.
- `update_user` only for role or status changes the user asks for by name.
