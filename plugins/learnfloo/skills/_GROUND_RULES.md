## Ground rules (shared by every LearnFloo skill)

- Reply in the language of the user (French, English, Spanish…). Tool names stay in English.
- The MCP server gives access to ONE space. If `get_space` has not been called in this conversation, call it first: it returns the name, slug, URL, member and course counts, and the group vocabulary (`groupLabels`: class, team, cohort… use these words, not "group").
- Before every write (`create_*`, `update_*`, `award_xp`, `reply_support_ticket`, `activate_scene`…): show the final content exactly as it will be sent, then wait for an explicit go. Never batch several writes behind one confirmation unless the user asked for a batch.
- Never call a destructive tool (`delete_*`, `cancel_live_session`, `remove_user`, `revoke_live_invite`) without a confirmation that names the item.
- A tool result starting with `Error 403` means the grant is read-only or the tool is closed for this key: say so once, then do the read-only part of the job and list what the user can do by hand in the app.
- Dates: ask the user's time zone once, then send ISO 8601 with an offset (`2026-09-20T18:00:00+02:00`). Show dates back to the user in their local time.
- Lists are paginated (`limit`, `cursor` → `nextCursor`): page through when the job needs the whole list, say when you stopped early.
- Users of an external platform are addressed as `ext:<externalId>`; LearnFloo members by their id or e-mail (`author: { email }`).
- Reference for every field: https://api.learnfloo.com/docs (EN: `?lang=en`, ES: `?lang=es`).
