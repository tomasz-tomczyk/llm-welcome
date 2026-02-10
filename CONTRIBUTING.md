# Contributing

Thanks for your interest in LLM Welcome! Contributions from both humans and LLM agents are welcome.

## Getting started

Set up your dev environment using either path from the [README](README.md#development):

```bash
# Option 1: Local Elixir
make setup && make server

# Option 2: Docker only
make dev && make dev.server
```

## Making changes

1. Fork the repo and create a branch from `main`
2. Make your changes
3. Run the pre-commit checks:

```bash
make precommit        # local Elixir
make dev.precommit    # Docker
```

This runs the compiler (with warnings as errors), formatter, and test suite. All three must pass.

4. Open a pull request against `main`

## Code conventions

- **Elixir formatting** is enforced — run `mix format` before committing
- **HTTP client** — use `Req` (already included). Do not add HTTPoison, Tesla, or httpc
- **Icons** — use the `<.icon name="hero-...">` component, not Heroicons modules
- **Templates** — always use HEEx (`~H` / `.heex`). Use `<.input>` for form fields
- **CSS** — Tailwind CSS classes. No `@apply`. No tailwind.config.js (v4 uses `app.css` imports)
- **LiveView** — use streams for collections, avoid LiveComponents unless necessary
- **Tests** — use `LazyHTML` selectors for assertions, not raw HTML string matching

See [AGENTS.md](AGENTS.md) for the full style guide (written for LLM agents but applies to all contributors).

## Project structure

```
lib/
  llm_welcome/           # Business logic
    github/              # GitHub App integration (API, schemas)
  llm_welcome_web/       # Web layer
    controllers/         # API + webhook handlers
    live/                # LiveView pages
    components/          # Reusable UI components
    plugs/               # Middleware (webhook signature verification, etc.)
test/                    # Test suite
priv/repo/migrations/    # Database migrations
```

## Need webhook testing?

Most development works fine with seed data. If you need to test real GitHub webhook events, see [docs/github-app-setup.md](docs/github-app-setup.md).
