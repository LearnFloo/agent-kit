---
name: prepare-live
description: Plan a LearnFloo live (webinar or conference) end to end - schedule, audience, replay rule, scenes from templates, polls and quizzes as drafts, invitation links for external speakers, announcement post. Use when the owner wants to create, schedule or prepare a live, a webinar, a class session or a launch.
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server, full access
---

# Prepare a live

## Ground rules
Follow `../_GROUND_RULES.md`. Every creation below is shown to the user first, then sent one at a time on their go.

## 1. Brief
Collect, in one message, what is missing among: title, date and time (with time zone), duration, format (`broadcast`: host and speakers only, default; `conference`: everyone on camera, small groups), expected audience size (`maxParticipants`, 2 to 1000), who can join (`groups`: whole space or some groups, use the space's group words), chat at arrival (`closed`, `open`, `off`), recording (default on), replay rule (`replay`: `all`, `attendees`, `groups`, `level`, `none`), host (`hostEmail`, must be owner, admin, moderator or teacher). Sensible defaults are fine: say which ones you apply.

## 2. Schedule
`create_live_session` with the agreed fields. Keep the returned `id` and `hostUrl`. Show the host URL: it is the page where the host starts the live.

## 3. Scenes (control room)
`list_scene_templates` first. Propose a sequence adapted to the goal, for instance:
- Waiting room: `layout: solo` with a media or embed slot, a `band` overlay "Starting at 18:00", a `viewers` widget, background sound with `audios` and `loop: true`.
- Intro: host solo, `showLogo: true`, `transition: fade`.
- Presentation: `sidebyside` or `pip` with a `screen` slot and the host.
- Guest: `spotlight` or `grid` with `guest` slots.
- Q&A: `grid`, a `message` overlay slot for staged chat messages, a `poll` overlay.
- Offer or next step: solo host with a `sticker` or `band` overlay carrying the price or the link, `durationSec` when it should auto-advance.
- Outro: media slot (video) with `once: true`, then `nextSceneId` to the waiting room or nothing.
Create them with `create_scene` from a template (`{ template: "name" }`) or from fields, in order (`afterId`). Give overlays stable ids (`price-band`, `next-step`) so the host can change them everywhere later with `update_overlay_everywhere`. Media must exist in the library: `list_media`, or `add_media` from an https URL. Check the result with `get_live_scenes` and summarise the running order.

## 4. Polls and quizzes
`create_poll` as drafts (no `open`): 2 to 6 options, `kind: quiz` with `correct` indexes when there is a right answer. Two or three well-placed polls beat ten.

## 5. People
- Speakers and staff with a LearnFloo account and already registered: `set_participant_role` (`speaker`, `assistant`, `moderator`) once they are registered on the live.
- External speaker, control-room assistant or moderator without an account: `create_live_invite` with the role, a label, `expiresInHours` and `maxUses: 1`. Show the link once; it is the only time it is displayed in full.
- Members: the app sends invitations by e-mail from the "Invitations" tab of the preparation page (not available through MCP). Say so.

## 6. Announce
Draft a feed post (`create_post`, category `announcements`, `groups` matching the audience) with the date in local time, what people will get, and the link of the space's calendar. Optional: pin it (`pinned: true`). The calendar event exists already: `create_live_session` created it (`list_events` shows it with `liveSessionId`).

## 7. Hand-over
Give the host a one-screen run sheet: scenes in order with what to say when switching, polls and when to open them, invitation links, the host URL. Mention that `live-control-room` drives the live once it runs.
