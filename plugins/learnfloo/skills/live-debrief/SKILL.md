---
name: live-debrief
description: Debrief a finished LearnFloo live - attendance and watch time, chat highlights and unanswered questions, poll and quiz results, replay links, then a recap post, a lesson built from the replay, and follow-up actions. Use after a live, webinar or class session, or when the owner asks "how did my live go".
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server, read access for the analysis, full access for the recap post and the lesson
---

# Live debrief

Follow `../_GROUND_RULES.md`. The analysis is read-only; the three follow-ups (recap post, lesson, XP) are shown before being sent.

## 1. Pick the live
`list_live_sessions` with `status: "ended"`: the latest by default, or the one the user names. `get_live_session` for schedule, mode, replay rule, conversions and counters.

## 2. Collect
- `get_live_attendance` → summary (attended, peak, average watch time, spectator and interactive hours) and per participant (joined at, minutes watched). Compute: attendance rate vs registered, share who stayed past the middle, top 10 by watch time.
- `get_live_chat` → all messages. Extract: questions without an answer in the chat, recurring topics, testimonials or wins worth quoting (with the author's first name), the timestamps of the peaks of activity.
- `list_live_polls` → each poll's counts; for quizzes the success rate. `get_live_poll` for details.
- `get_live_replay` → MP4, HLS, embed URLs, thumbnail, duration, views, linked lesson (if any).
- `get_live_scenes` → which scenes existed (to comment on the run sheet, not to change it).

## 3. Report
Short, in the user's language:
- **Numbers** (table): registered, attended, peak, average watch time, chat messages, conversions, replay views.
- **What people asked**: the unanswered questions, grouped, ready to answer.
- **What resonated**: the moments with the most chat activity, the poll results in one line each.
- **What to fix next time**: 2-3 concrete points (arrival time, drop-off moment, a scene that stayed too long).

## 4. Follow-ups (each one on the user's go)
- **Recap post** in the feed: `create_post`, category `announcements` or `resource`, `groups` matching the live's audience, with the 3 key takeaways, the answers to the open questions, the replay link (only if the replay rule allows the audience to watch, see `get_live_session.replay`).
- **Lesson from the replay**: `list_courses`, then `create_lesson` in the course and module the user chooses (`create_module` if needed) with `videoUrl` = the replay's MP4 or HLS URL, `videoDurationSec`, and the takeaways as content. Ask before publishing the course if it is a draft.
- **Reward attendees** when the space uses gamification: `award_xp` per attendee (`get_live_attendance` list), reason `live-attended`, `refId` = the live id (idempotent). Show the count and the amount first; skip people below a minimum watch time the user sets.
- **Answer questions**: for each open question, draft an answer; post it as a comment on the recap post (`create_comment`) once approved.
