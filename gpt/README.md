# GPT « LearnFloo » (ChatGPT)

A custom GPT for space owners, built on the LearnFloo REST API through a **GPT Action** (OpenAPI + OAuth). ChatGPT does not read MCP servers from a GPT, so the GPT uses the same API through an OpenAPI file limited to 30 operations (ChatGPT's limit per action).

Anyone with a ChatGPT account can use a published GPT; each owner authorizes their own space on the LearnFloo consent page, so one GPT serves every space.

## Files

- `INSTRUCTIONS.md`: the instructions of the GPT (the rules of the Agent Kit skills, condensed for a GPT).
- OpenAPI file: `https://api.learnfloo.com/openapi.json?preset=gpt` (30 operations, OAuth only). The full API is at `https://api.learnfloo.com/openapi.json`; `?tools=a,b,c` or `?groups=live,courses` pick another subset.

## Create the GPT (LearnFloo team)

1. **OAuth client** (once, by ops, prints the secret once):
   ```sh
   npx convex run oauthOps:createConfidentialClient '{"name":"ChatGPT · LearnFloo","redirectUris":["https://chat.openai.com/aip/*/oauth/callback","https://chatgpt.com/aip/*/oauth/callback"]}' --prod
   ```
   The `*` stands for the GPT id (`g-…`), known only after the GPT exists.
2. In ChatGPT: **Explore GPTs → Create → Configure**. Name « LearnFloo », description « Pilotez votre communauté LearnFloo : bilan, lives, fil, membres, support », instructions = `INSTRUCTIONS.md`, conversation starters: « Bilan de mon espace », « Prépare mon prochain live », « Débrief du dernier live », « Qui relancer cette semaine ? ».
3. **Actions → Create new action → Import from URL**: `https://api.learnfloo.com/openapi.json?preset=gpt`.
4. **Authentication → OAuth**:
   - Client ID / Client Secret: from step 1.
   - Authorization URL: `https://api.learnfloo.com/oauth/authorize`
   - Token URL: `https://api.learnfloo.com/oauth/token`
   - Scope: `full` (or `read` for a read-only GPT)
   - Token exchange method: **Default (POST request)**
   - PKCE: enabled (S256) — the LearnFloo server requires it.
5. Copy the **Callback URL** shown by ChatGPT (`https://chatgpt.com/aip/g-…/oauth/callback`): it matches the wildcard registered in step 1, nothing else to do.
6. Privacy policy URL (required to publish): the LearnFloo privacy page.
7. Test: ask « Bilan de mon espace » → ChatGPT opens the LearnFloo consent page → pick the space, the access level and the tools → back in ChatGPT, the report arrives.
8. Publish: **Save → Anyone with the link** first, then **GPT Store** once the domain `learnfloo.com` is verified in the builder profile.

## How the authorization works

- The consent page lists the spaces the signed-in user owns or administers, an access level (read or full) and the tools to open. The grant appears in Space settings → API and MCP, next to the API keys, and can be revoked there.
- The access token is accepted by the REST API and by the MCP server; on the REST API it opens only the routes of the chosen tools (one tool = one route, same names as in the OpenAPI `operationId`s).
- Tokens last one hour, refreshed automatically by ChatGPT (30-day refresh tokens, rotated).
