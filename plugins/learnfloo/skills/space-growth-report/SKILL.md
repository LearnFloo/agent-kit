---
name: space-growth-report
description: Growth report of a LearnFloo space that joins acquisition (who visits the public pages, from where, which campaigns convert) with what happens after the join (activity, courses, lives, retention), with concrete next actions. Use when the owner asks "where do my members come from", "is my Instagram / my ads / my newsletter working", "why do visitors not join", for a weekly or monthly growth review, or before spending on ads.
license: MIT
metadata:
  author: LearnFloo
  version: "1.0"
  requires: LearnFloo MCP server (https://api.learnfloo.com/mcp), read access is enough
---

# Space growth report

Read-only skill: it never writes. It works with a read-only grant.

## Ground rules
Follow the shared rules in `../_GROUND_RULES.md` (reply in the user's language, `get_space` first, paginate, dates in local time).

## Steps
1. `get_space` → name, slug, visibility, paid or free access, price. `get_space_usage` → `tier.name` (UTM campaigns and the funnel need `pro` or `entreprise`).
2. Acquisition: `get_space_audience` with `days` = the period the user asked for (default 30) and `tz` = their time zone. If `configured` is false, say statistics are not enabled yet and continue with steps 4-6 only. Note `totals` and their `previous` values, `sources`, `channels`, `pages`, `countries`, `conversions`. When `pro` is true, read `utm` and `funnel`; when false, mention once that campaigns and the funnel come with the Pro tier.
3. If the user compares two periods, call `get_space_audience` again with the longer window only when the difference is meaningful (e.g. 30 vs 90 days); never invent the previous period otherwise.
4. After the join: `list_users` (page through, stop at 1 000 and say so) → members who joined in the period (`member.joinedAt`). `get_retention` with the same `days` → drifting members and exit reasons.
5. Activation: `list_courses` → for the first published course (or the one the user names) `get_course_progress` → share of the period's newcomers who started it. `list_live_sessions` (status `ended`, in the period) → `get_live_attendance` for the latest one.
6. Money (paid space): `conversions.checkouts` vs `conversions.paid` (checkout drop), `conversions.eventPaid`. Revenue itself lives in the owner's Stripe dashboard; do not estimate it.

## Output
Short sentences, numbers in a table, no jargon:
- **Headline**: one line, the single most important fact (e.g. "Instagram brings 60 % of visitors but only 1 join in 20; the newsletter converts 4 times better").
- **Traffic**: visitors, visits, bounce rate, average time, vs previous period (only if `previous` is non-zero).
- **Where members come from**: top 3 sources or UTM campaigns with visitors → joins when known; the conversion rate.
- **Funnel** (Pro): visit → join, or visit → checkout → paid, with the biggest drop named.
- **After the join**: newcomers of the period, how many started the first course, came to a live, are drifting; top exit reasons.
- **Next 3 actions**, each concrete: fix the about page (description, presentation video, price), push the source that converts (with a UTM link to use: `?utm_source=…&utm_medium=…&utm_campaign=…`), welcome sequence (`animate-community`, `follow-up-members`), a live for newcomers (`prepare-live`), add or check the Meta / GA4 pixel IDs in Settings → Access before running ads. Offer to run one.

## Never
- Never present a trend without both periods in the data.
- Never promise ad results; give the measured conversion rate and what to test.
- Never ask for or show personal data of visitors: statistics are anonymous by design.
