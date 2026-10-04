# LearnFloo Agent Kit

*[Version française](README.md)*

Run your LearnFloo space with an AI assistant: Claude (Claude Code, the Claude app, claude.ai), Codex, Cursor, Gemini CLI or any MCP client.

The kit holds two things:

1. **A Claude Code plugin** (`plugins/learnfloo`) that connects the LearnFloo MCP server and brings nine job-oriented *skills*.
2. **The same skills in the open [Agent Skills](https://agentskills.io) format** (`skills/`), installable in Codex, Cursor, Gemini CLI and every assistant that reads `SKILL.md` files.

The MCP server (`https://api.learnfloo.com/mcp`) exposes one tool per route of the LearnFloo API: members, courses, lives, scenes, polls, feed, groups, tickets, media library, webhooks. Reference: <https://api.learnfloo.com/docs?lang=en#mcp>. The same recipes are also served by the server itself as MCP *prompts*: a client that lists prompts (Claude, Cursor…) offers them with nothing to install.

## The skills

| Skill | What it does | Access |
|---|---|---|
| `space-report` | Health report of the space: members, activity, courses, lives, support, usage and costs, three next actions | read |
| `space-growth-report` | Growth of the space: where visitors come from, which sources and campaigns convert, what happens to newcomers, three next actions | read |
| `install-integration` | Connect LearnFloo to HubSpot, Brevo, Mailchimp, Google Sheets, Slack, Discord, Notion or Calendly from the [learnfloo/integrations](https://github.com/learnfloo/integrations) recipes: webhook created, test sent | write |
| `prepare-live` | Plans a live end to end: date, audience, replay rule, scenes from templates, draft polls, invitation links, announcement | full |
| `live-control-room` | Drives a running live: scenes, bands, polls, staged messages, speakers, conversions | full |
| `live-debrief` | After the live: attendance, open questions, poll results, replay, recap post, lesson from the replay, XP | read (analysis) / full (follow-ups) |
| `meeting-tasks-sync` | Copies the tasks of meeting recaps (recorded visios, webinars) into Asana, Trello, Notion, Linear… and keeps both sides checked in step, in the conversation or permanently through webhooks; reads a recap, asks a meeting, rewrites it with another template | read / full |
| `build-course` | Builds a course from an outline, a document or a transcript: modules, HTML lessons with video, publication, progress | full |
| `animate-community` | Animates the feed: welcomes, answers to questions, wins, weekly calendar, per-group posts | full |
| `follow-up-members` | Re-engagement: silent newcomers, stalled learners, falling actives, champions; XP, groups, targeted posts | read / full |
| `support-inbox` | Triages and answers support tickets, priorities, assignment, recurring issues | full |
| `learnfloo-integration` | For developers: external ids, SSO entry URLs, synced groups, XP and lesson completion, webhooks, keys and OAuth | read |

Every skill follows the shared rules in `skills/_GROUND_RULES.md`: reply in the user's language, call `get_space` first, **show the final content before any write and wait for the go**, no deletion without a named confirmation, and do the read-only part when the grant is read-only.

## Install

### Claude Code

```sh
claude plugin marketplace add learnfloo/agent-kit
claude plugin install learnfloo@learnfloo
```

Then, inside Claude Code, `/mcp` → `learnfloo` → **Authenticate**: the LearnFloo consent page opens, you pick the space, the access level (read-only or full) and the open tools. Skills are available as `/learnfloo:prepare-live`, `/learnfloo:space-report`, etc., and Claude loads them on its own when a request matches.

With an API key instead of OAuth: `export LEARNFLOO_MCP_URL="https://api.learnfloo.com/mcp?key=lf_live_…"` before starting `claude` (keys are created in Space settings → API and MCP; a **read-only** key is the right choice for reports).

Local test without installing: `claude --plugin-dir ./plugins/learnfloo`.

### Claude app and claude.ai

Settings → Connectors → Add custom connector, URL `https://api.learnfloo.com/mcp`, then **Connect**. The recipes show up as prompts of the connector. Nothing else to install.

### Codex

```sh
./install.sh codex          # copies the skills into ~/.codex/skills
codex mcp add learnfloo --url https://api.learnfloo.com/mcp
codex mcp login learnfloo
```

In Codex, call a skill with `$prepare-live`, or let it trigger on its own.

### Cursor

```sh
./install.sh cursor          # ~/.cursor/skills; add --project for .cursor/skills
```

Then in `.cursor/mcp.json`: `{ "mcpServers": { "learnfloo": { "url": "https://api.learnfloo.com/mcp" } } }`.

### Gemini CLI and others

```sh
./install.sh gemini          # ~/.gemini/skills
./install.sh agents          # ~/.agents/skills, read by several assistants
```

MCP server in `~/.gemini/settings.json`: `{ "mcpServers": { "learnfloo": { "httpUrl": "https://api.learnfloo.com/mcp" } } }`.

## GPT for ChatGPT

ChatGPT does not read MCP servers from a GPT: the [`gpt/`](gpt/) folder holds the instructions of the “LearnFloo” GPT and the steps to build it with an *Action* (OpenAPI file `https://api.learnfloo.com/openapi.json?preset=gpt`, 30 operations, OAuth).

## Security

- Prefer **OAuth**: no secret in the configuration, a grant you can revoke in the space settings, actions attributed to your account.
- For reading jobs (reports, debriefs, follow-up), give a **read-only** grant: the skills adapt.
- The skills delete nothing and publish nothing without showing you the content and asking for an explicit go. Stay attentive all the same: an assistant holding a full-access key can, at your request, write into the space.

## Contribute

One skill = one folder `skills/<name>/SKILL.md` (front matter `name`, `description`, Markdown body in English for the model, which answers in the user's language). Tool names quoted must exist in the MCP catalogue (listed in the reference). Open a pull request.

MIT licence.
