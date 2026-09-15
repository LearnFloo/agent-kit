# LearnFloo Agent Kit

*[English version](README.en.md)*

Faites tourner votre espace LearnFloo avec un assistant IA : Claude (Claude Code, application Claude, claude.ai), Codex, Cursor, Gemini CLI ou tout client MCP.

Le kit contient deux choses :

1. **Un plugin Claude Code** (`plugins/learnfloo`) qui branche le serveur MCP de LearnFloo et apporte neuf *skills* métier.
2. **Les mêmes skills au format ouvert [Agent Skills](https://agentskills.io)** (`skills/`), installables dans Codex, Cursor, Gemini CLI et les autres assistants qui lisent des fichiers `SKILL.md`.

Le serveur MCP (`https://api.learnfloo.com/mcp`) expose un outil par route de l'API LearnFloo : membres, cours, lives, scènes, sondages, fil, groupes, tickets, médiathèque, webhooks. Référence : <https://api.learnfloo.com/docs#mcp>. Les mêmes recettes sont aussi servies par le serveur lui-même comme *prompts* MCP : un client qui affiche les prompts (Claude, Cursor…) les propose sans rien installer.

## Les skills

| Skill | Ce qu'il fait | Accès requis |
|---|---|---|
| `space-report` | Bilan de santé de l'espace : membres, activité, cours, lives, support, usage et coûts, trois actions à mener | lecture |
| `prepare-live` | Planifie un live de A à Z : date, audience, replay, scènes depuis les modèles, sondages en brouillon, liens d'invitation, annonce | complet |
| `live-control-room` | Régie pendant le live : scènes, bandeaux, sondages, messages à l'écran, prise de parole, conversions | complet |
| `live-debrief` | Après le live : présence, questions sans réponse, résultats des sondages, replay, post récap, leçon depuis le replay, XP | lecture (analyse) / complet (suites) |
| `build-course` | Construit un cours depuis un plan, un document ou une transcription : modules, leçons HTML + vidéo, publication, suivi | complet |
| `animate-community` | Anime le fil : bienvenue, réponses aux questions, victoires, calendrier de la semaine, posts par groupe | complet |
| `follow-up-members` | Relance : nouveaux silencieux, apprenants bloqués, actifs en baisse, champions ; XP, groupes, posts ciblés | lecture / complet |
| `support-inbox` | Trie et répond aux tickets de support, priorités, affectation, problèmes récurrents | complet |
| `learnfloo-integration` | Pour les développeurs : identifiants externes, SSO, groupes synchronisés, XP et leçons, webhooks, clés et OAuth | lecture |

Chaque skill suit les règles communes de `skills/_GROUND_RULES.md` : répondre dans la langue de l'utilisateur, appeler `get_space` d'abord, **montrer le contenu final avant toute écriture et attendre l'accord**, jamais de suppression sans confirmation nommée, et se contenter de la lecture quand la clé est en lecture seule.

## Installation

### Claude Code

```sh
claude plugin marketplace add learnfloo/agent-kit
claude plugin install learnfloo@learnfloo
```

Puis, dans Claude Code, `/mcp` → `learnfloo` → **Authenticate** : la page d'autorisation LearnFloo s'ouvre, vous choisissez l'espace, le niveau d'accès (lecture seule ou complet) et les outils ouverts. Les skills sont disponibles sous `/learnfloo:prepare-live`, `/learnfloo:space-report`, etc., et Claude les charge seul quand la demande correspond.

Avec une clé API plutôt qu'OAuth : `export LEARNFLOO_MCP_URL="https://api.learnfloo.com/mcp?key=lf_live_…"` avant de lancer `claude` (clé créée dans Paramètres de l'espace → API et MCP ; une clé en **lecture seule** est le bon choix pour les bilans).

Test local sans installer : `claude --plugin-dir ./plugins/learnfloo`.

### Application Claude et claude.ai

Paramètres → Connecteurs → Ajouter un connecteur personnalisé, URL `https://api.learnfloo.com/mcp`, puis **Connecter**. Les recettes apparaissent comme prompts du connecteur. Rien d'autre à installer.

### Codex

```sh
./install.sh codex          # copie les skills dans ~/.codex/skills
codex mcp add learnfloo --url https://api.learnfloo.com/mcp
codex mcp login learnfloo
```

Dans Codex, appelez un skill avec `$prepare-live`, ou laissez-le se déclencher.

### Cursor

```sh
./install.sh cursor          # ~/.cursor/skills ; ajoutez --project pour .cursor/skills
```

Puis dans `.cursor/mcp.json` : `{ "mcpServers": { "learnfloo": { "url": "https://api.learnfloo.com/mcp" } } }`.

### Gemini CLI et autres

```sh
./install.sh gemini          # ~/.gemini/skills
./install.sh agents          # ~/.agents/skills, lu par plusieurs assistants
```

Serveur MCP dans `~/.gemini/settings.json` : `{ "mcpServers": { "learnfloo": { "httpUrl": "https://api.learnfloo.com/mcp" } } }`.

## Sécurité

- Préférez **OAuth** : aucun secret dans la configuration, autorisation révocable dans les paramètres de l'espace, actions attribuées à votre compte.
- Pour un usage en lecture (bilans, débriefs, suivi), donnez un accès **lecture seule** : les skills s'y adaptent.
- Les skills ne suppriment rien et ne publient rien sans vous avoir montré le contenu et demandé un accord explicite. Restez néanmoins attentif : un assistant qui a une clé complète peut, à votre demande, écrire dans l'espace.

## Contribuer

Un skill = un dossier `skills/<nom>/SKILL.md` (en-tête `name`, `description`, corps en Markdown, en anglais pour le modèle, qui répond dans la langue de l'utilisateur). Les noms d'outils cités doivent exister dans le catalogue MCP (la liste est dans la référence). Ouvrez une *pull request*.

Licence MIT.
