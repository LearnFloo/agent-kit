---
name: animate-community
description: Animate the feed of a LearnFloo space - welcome new members, answer open questions, celebrate wins, weekly posts (question of the week, resource, challenge reminder), pinned announcements, per-group posts. Use when the owner wants ideas or drafts for the feed, a content calendar, or asks "what should I post".
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server, full access to post (read access to draft only)
---

# Animate the community

Follow `../_GROUND_RULES.md`. Every post and comment is shown in full and sent only on the user's go, one at a time. Write in the tone of the space: read 10 recent posts first and match it (formal or friendly, emojis or not, length).

## 1. Read the room
- `get_space` → name, group words, counts.
- `list_posts` limit 30 → recent rhythm, categories used, who posts, what gets comments.
- `list_posts` with `category: "question"` → questions with 0 comments: these come first.
- `list_posts` with `category: "wins"` → wins to celebrate.
- `list_users` limit 50 → newest members (by `joinedAt` when present) to welcome.
- `list_challenges`, `list_events` (30 days), `list_live_sessions` status `scheduled` → things to remind.

## 2. Propose a short plan
Five items at most, each: goal, category, audience (whole space or a group), day. Categories: `general`, `announcements`, `question`, `wins`, `resource`. Typical week:
- Monday: question of the week (`question`) to start conversations.
- Wednesday: a resource (`resource`) linked to a course lesson or the last live replay.
- Friday: wins round-up (`wins`) quoting members by first name, and a reminder of next week's live.
- On demand: a welcome post naming the new members (`general`), an `announcements` post, pinned, for what matters.

## 3. Draft and send
- Posts: `create_post` with `title`, `category`, `content` (plain text, blank line = new paragraph, or `format: "html"`), `groups` when addressed to a group, `pinned: true` for announcements the user wants on top. Attachments must be stored beforehand through the REST route `POST /api/v1/attachments` (not available through MCP): say so when the user wants an image.
- Answers to questions: `get_post` to read the full question and existing comments, draft an answer, `create_comment` on the post (`parentCommentId` for a reply to a comment).
- Author: by default the creator of the key; `author: { email }` posts as another staff member who agreed.

## 4. Do not
- Do not post twice on the same topic in a week; check `list_posts` before sending.
- Do not answer a question with a guess: when the answer depends on the space's content, quote the lesson or the replay (`get_course`, `get_live_replay`).
- Do not delete or edit members' posts unless the user names the post and asks.
