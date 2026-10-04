---
name: meeting-tasks-sync
description: Copy the tasks of LearnFloo meeting recaps (who does what, decided in a recorded visio or webinar) into a task manager - Asana, Trello, Notion, Linear or any other - and keep both sides checked in step, by hand in the conversation or permanently through webhooks. Also reads a recap, answers questions about a meeting and rewrites a recap with another template. Use when the user asks to "send the meeting tasks to Asana", "sync my action items", "what was decided in yesterday's meeting", "who has to do what".
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server (read access to read recaps and tasks, full access to link or check tasks, ask questions and rewrite); for the in-conversation sync, a connector of the task manager (Asana, Linear, Notion, Trello…) in the same assistant
---

# Meeting tasks → task manager

Follow `../_GROUND_RULES.md`. Reading recaps and tasks is free; linking, checking, rewriting and asking are writes or cost AI credits: show what will happen and wait for a go.

## 1. Find the meeting
- `list_meeting_recaps` (newest first, `status: "ready"` by default for the user's purpose). Show title, date (`session.startedAt`, in the user's time zone), number of open tasks. The latest by default, or the one the user names.
- `get_meeting_recap` for the full recap: summary, sections (decisions, next steps…), tasks with assignee, deadline (`dueAt`, or `due` as said in the meeting) and the moment they were said (`atSec`, show it as mm:ss).
- Questions about what was said ("did we agree on the price?"): `ask_meeting` with the question. It answers from the transcript only, with moments; it costs AI credits and fails once the transcript was erased by the space's retention rule — say so, the written recap stays readable.
- A recap written with the wrong template (sales call written as a team meeting…): `list_meeting_templates`, then `regenerate_meeting_recap` with the right `template` after a go (billed again; open tasks are replaced by new ones, done ones kept). It answers at once with status generating: check back with `get_meeting_recap`.

## 2. Choose the mode
Ask once which tool holds their tasks and how they want it:
- **Now, in this conversation** — needs a connector of that tool in this assistant (Asana, Linear, Notion, Trello MCP…). If there is none, say so and propose mode B.
- **Automatically, from now on** — mode B, webhooks.

## 3A. Sync in the conversation
1. `list_meeting_tasks` with `status: "open"` (and `recapId` for one meeting). Keep the tasks whose `externalSystem` is null: the others are already copied (never copy twice).
2. Map each task to a card: title = `text`; due date = `dueAt`; assignee = match `assignee.email` (or name) with the tool's users, leave unassigned when unsure and say it; description = the meeting title, the moment (mm:ss) and the link `https://app.learnfloo.com` + the recap's `url`. Tasks whose `assignee.id` is null name someone who was not in the room: keep the name in the description.
3. Show the list of cards to create (table: task, person, due date, project or board). Ask for the project, board or database once. Wait for a go.
4. Create the cards with the tool's connector, then for each one `update_meeting_task` with `externalSystem` (lowercase tool name: asana, trello, notion, linear…) and `externalRef` (the card id, or its URL when the tool has no short id).
5. Back-sync: for the tasks with this `externalSystem`, read the cards' state in the tool; when a card is completed and the task is still open, `update_meeting_task` with `status: "done"` (this sends the meeting.task.done webhook). When a task is done in LearnFloo and the card open, propose to close the card. Show the list of changes before applying.
6. Report: created, linked, checked, skipped (and why).

## 3B. Automatic sync with webhooks
1. The recipe "Tasks → Asana, Trello, Notion, Linear" in https://api.learnfloo.com/docs#meeting-tasks-sync (EN `?lang=en`, ES `?lang=es`) is the reference; integration recipes for n8n, Make, Zapier and Node.js live at https://github.com/learnfloo/integrations.
2. The user prepares the receiving side (a workflow URL in n8n, Make or Zapier, or their server) and the tool's credential in their own account; never ask for a password.
3. `create_webhook` with that URL and the events meeting.task.created and meeting.task.done (meeting.recap.ready too if they want the full recap). Give them the signing secret once; it is not shown again.
4. The workflow must, on meeting.task.created: skip a task that already has an `externalRef` (a webhook can be delivered twice), create the card, then call PATCH /meeting-tasks/:id with `externalSystem` and `externalRef`; when the card is completed in the tool: PATCH /meeting-tasks/:id with `status: "done"`; on meeting.task.done: close the card `externalRef`.
5. `test_webhook`, then check `list_webhook_deliveries` (status code and response) with the user.
6. Existing open tasks are not replayed by the webhook: do one catch-up with mode 3A, or have the workflow page through GET /meeting-tasks?status=open.

## Rules
- A regenerated recap replaces its open tasks with new ones (new ids, new meeting.task.created): warn that the cards of the old open tasks should be closed in the tool.
- Assignees: `update_meeting_task` with `assignee` notifies that member in LearnFloo; only change it when the user asks.
- Recaps can hold confidential content (versions exist for clients and external readers): copy only the tasks, not the discussion, unless the user asks; never paste a transcript into another tool.
- Every read of a recap through the API is written to its access log, visible to the host: mention it if the user worries about discretion.
