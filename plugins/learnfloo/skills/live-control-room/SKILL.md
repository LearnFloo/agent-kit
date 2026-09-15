---
name: live-control-room
description: Drive a running LearnFloo live from the control room - switch scenes, show bands, open and close polls, stage chat messages, give the floor, announce conversions, watch who is connected. Use when a live is on air and the host or an assistant asks for a change on screen, a poll, or a status.
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server, full access
---

# Live control room

During a live, speed matters more than ceremony. This skill relaxes one ground rule: a scene switch, a band, a poll opening or a staged message asked for explicitly by the user is done immediately, without an extra confirmation. Everything else in `../_GROUND_RULES.md` holds (destructive actions still need a named confirmation).

## Find the live
`list_live_sessions` with `status: "live"`. One running live: use it and say its title. Several: ask. None: say the live has not started; `get_live_session` on a scheduled one gives its schedule and host URL.

## Know the room
- `get_live_scenes` → scenes with ids, active scene, auto-advance, media state. Keep this list in mind; refresh it after each structural change.
- `get_live_participants` → connected, spectators, hands raised, roles. Answer "who is here" from it.
- `get_live_chat` → messages with ids, for staging or answering.
- `list_live_polls` → polls with ids and status.

## Actions, one tool each
| The user says | Do |
|---|---|
| "scene X", "go to intro", "next" | `activate_scene` with the scene id (next = the one after the active scene in the list) |
| "back to automatic", "cameras" | `set_active_scene` with `sceneId: null` |
| "start / stop the sequence" | `set_auto_advance` |
| "band: 10 minutes break" | `show_band` with the text (a few seconds on every screen) |
| "change the price band to 49 €" | `update_overlay_everywhere` with the overlay id (from `get_live_scenes`) and `{ text }` |
| "hide the sticker" | `update_overlay` with `{ visible: false }` |
| "put this message on screen" | `stage_chat_message` with the `messageId` from `get_live_chat`; `null` removes it |
| "launch the poll about…" | `open_poll` (draft exists) or `create_poll` with `open: true` |
| "close it and show results" | `close_poll`, then `show_poll_results` `shown: true` if hidden; `show_poll_band` for a 12 s band with the leading answers |
| "put the poll on screen" | `stage_poll` `shown: true` |
| "give Marie the floor" | `set_participant_role` role `speaker` (`userId` from `get_live_participants`); `viewer` takes it back |
| "make Paul moderator / assistant" | `set_participant_role` with `moderator` or `assistant` |
| "someone just bought" | `report_live_conversion` (announced in the chat and on the scene, counted in the report) |
| "add 40 viewers to the counter" | `set_extra_viewers` (widget only, never billed or counted in attendance) |
| "next page of the PDF", "play the video" | `control_scene_media` with the media id from `get_live_scenes` |
| "a link for a guest speaker, now" | `create_live_invite` role `speaker`, `expiresInHours: 2`, `maxUses: 1` |

## Answer in one line
After each action, confirm in one short line what is on air now. Do not paste tool results. When something fails (`Error 4xx`), say what and offer the fallback (for example the host can do it from the control room panel).

## Hands raised and questions
When asked, list raised hands in order (`get_live_participants`) and unanswered questions from the chat (`get_live_chat`, newest 50), grouped by topic, with the message ids ready for staging.
