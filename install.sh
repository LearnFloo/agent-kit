#!/usr/bin/env sh
# Installs the LearnFloo skills for an assistant other than Claude Code, and prints its MCP configuration.
# Usage: ./install.sh codex | cursor | gemini | agents     (add --project to install in the current project instead of the home directory)
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
SRC="$HERE/plugins/learnfloo/skills"
TARGET="$1"; SCOPE="$2"
case "$TARGET" in
  codex)  DIR="$HOME/.codex/skills";  [ "$SCOPE" = "--project" ] && DIR=".codex/skills" ;;
  cursor) DIR="$HOME/.cursor/skills"; [ "$SCOPE" = "--project" ] && DIR=".cursor/skills" ;;
  gemini) DIR="$HOME/.gemini/skills"; [ "$SCOPE" = "--project" ] && DIR=".gemini/skills" ;;
  agents) DIR="$HOME/.agents/skills"; [ "$SCOPE" = "--project" ] && DIR=".agents/skills" ;;
  *) echo "Usage: $0 codex|cursor|gemini|agents [--project]"; echo "Claude Code: claude plugin marketplace add learnfloo/agent-kit && claude plugin install learnfloo@learnfloo"; exit 1 ;;
esac
mkdir -p "$DIR"
# One folder per skill; the shared rules file sits next to them so the ../_GROUND_RULES.md reference stays valid.
for skill in "$SRC"/*/; do
  name=$(basename "$skill")
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$skill" "$DIR/$name/"
  else
    mkdir -p "$DIR/$name" && cp -R "$skill". "$DIR/$name/"
  fi
done
cp "$SRC/_GROUND_RULES.md" "$DIR/_GROUND_RULES.md"
echo "Skills installed in $DIR:"; ls "$DIR" | grep -v '^_' | sed 's/^/  - /'
echo
echo "MCP server (OAuth: the assistant opens the LearnFloo sign-in page; API key: replace the URL by https://api.learnfloo.com/mcp?key=lf_live_… or send the Authorization header):"
case "$TARGET" in
  codex) cat <<'T'
  codex mcp add learnfloo --url https://api.learnfloo.com/mcp
  codex mcp login learnfloo
  # or in ~/.codex/config.toml, with an API key:
  # [mcp_servers.learnfloo]
  # url = "https://api.learnfloo.com/mcp"
  # bearer_token_env_var = "LEARNFLOO_API_KEY"
T
  ;;
  cursor) cat <<'T'
  .cursor/mcp.json (project) or ~/.cursor/mcp.json:
  { "mcpServers": { "learnfloo": { "url": "https://api.learnfloo.com/mcp" } } }
  # with an API key: { "url": "https://api.learnfloo.com/mcp", "headers": { "Authorization": "Bearer ${env:LEARNFLOO_API_KEY}" } }
T
  ;;
  gemini) cat <<'T'
  ~/.gemini/settings.json:
  { "mcpServers": { "learnfloo": { "httpUrl": "https://api.learnfloo.com/mcp" } } }
  # with an API key: { "httpUrl": "https://api.learnfloo.com/mcp", "headers": { "Authorization": "Bearer ${LEARNFLOO_API_KEY}" } }
T
  ;;
  agents) echo "  Configure the MCP server in your client: URL https://api.learnfloo.com/mcp (see https://api.learnfloo.com/docs#mcp-clients)" ;;
esac
