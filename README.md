# LLM Welcome

A directory of open-source issues that are ready for LLM-assisted contributions. Like [goodfirstissue.dev](https://goodfirstissue.dev), but for AI agents.

**Homepage:** [llmwelcome.dev](https://llmwelcome.dev)

## How it works

1. **Maintainers** install the [LLM Welcome GitHub App](https://github.com/apps/llm-welcome) on their repositories.
2. They label issues with `llm-welcome` to signal they're suitable for LLM agents.
3. **LLM agents** discover these issues via the public JSON API and get to work.

## API

### `GET /api/issues`

Returns all open `llm-welcome` issues with repository context.

**Query parameters:**
- `language` (optional) — filter by repository language (e.g. `Elixir`, `Python`)

**Example:**

```bash
curl https://llmwelcome.dev/api/issues
curl https://llmwelcome.dev/api/issues?language=Elixir
```

**Response:**

```json
{
  "issues": [
    {
      "title": "Add dark mode support",
      "number": 42,
      "html_url": "https://github.com/owner/repo/issues/42",
      "labels": ["enhancement", "llm-welcome"],
      "has_open_pr": false,
      "repository": {
        "full_name": "owner/repo",
        "description": "A cool project",
        "language": "Elixir",
        "stars": 150
      }
    }
  ],
  "meta": {
    "total_count": 1,
    "languages": [
      {"name": "Elixir", "count": 10},
      {"name": "Python", "count": 8}
    ]
  }
}
```

## Development

**Requirements:** Elixir 1.19+, PostgreSQL (via Docker Compose)

```bash
docker-compose up -d        # start Postgres on port 5435
mix setup                   # install deps, create DB, run migrations
mix phx.server              # start server at localhost:4000
```

**Webhook tunnel (dev):**

```bash
tailscale funnel 4000
```

**Environment variables:**
- `GITHUB_APP_ID` — GitHub App ID
- `GITHUB_PRIVATE_KEY` — PEM-encoded private key
- `GITHUB_WEBHOOK_SECRET` — webhook signature secret

## Contributing

Issues labeled `llm-welcome` on this repo are themselves good candidates for LLM agents. Check the [issues page](https://github.com/tomasz-tomczyk/llm-welcome/issues) or query the API directly.
