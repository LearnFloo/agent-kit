---
name: build-course
description: Build or extend a LearnFloo course from an outline, a document, a transcript or a set of videos - course, modules, lessons with rich HTML content and video, audience, publication, then a check of learner progress. Use when the owner wants to create a course, turn content into lessons, restructure modules, or publish.
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server, full access
---

# Build a course

Follow `../_GROUND_RULES.md`. Show the outline before creating anything, then create in order: course, modules, lessons. One tool call per item; report progress every 5 lessons.

## 1. Existing material
`list_courses` with `includeUnpublished: true`: do not create a duplicate of an existing course; propose to extend it (`get_course` with `withContent: true` to see what is there). For videos already in the space: `list_videos` (studio recordings and live replays) and `get_video` for playback URLs, or `list_media` for library files.

## 2. Outline
From the user's source (text, document pasted, transcript, list of videos), propose:
- Title, one-paragraph description, cover (an https image URL if the user has one).
- Modules (3 to 8) with a goal each.
- Lessons per module (2 to 6), each with a title, a 1-line promise, and whether it has a video.
- Audience: whole space or some groups (use the space's group words).
Ask for the go, or edits, before creating.

## 3. Create
- `create_course` with `published: false`, `groups` if restricted. Keep the id or slug.
- `create_module` per module, in order. Keep ids.
- `create_lesson` per lesson with `moduleId`, `format: "html"`, `content` as clean HTML (`<h2>`, `<p>`, `<ul>`, `<blockquote>`, `<strong>`; no inline styles, no scripts), `videoUrl` (MP4, HLS, YouTube, Vimeo, or a studio `playbackUrl`) and `videoDurationSec` when known.
- Lesson content: 200 to 600 words when written from a transcript, with a short intro, the steps or key ideas, an exercise or a question, and what comes next. Keep the author's voice; do not pad.
- `update_lesson` to fix order or move a lesson to another module.

## 4. Check and publish
`get_course` to display the final structure. Then, on the user's go, `update_course` with `published: true`. Suggest an announcement post (`create_post`, category `announcements`) with the course URL from `get_space`.

## 5. Later: progress
`get_course_progress` gives every learner who started (most advanced first) and, with `externalId` or `userId`, the lesson-by-lesson detail of one person. Use it to spot the lesson where learners stop and propose a fix (split it, add a video, add a live Q&A with `prepare-live`).
