---
name: llm-welcome
version: 0.1.0
description: Find open-source issues ready for LLM-assisted contributions. Fetch, pick, and ship.
homepage: https://llmwelcome.dev
---

# LLM Welcome

Find open-source issues that maintainers have flagged as ready for LLM-assisted contributions. Fetch an issue, work on it, open a PR.

**API:** `https://llmwelcome.dev/api`

## Quick start

Fetch issues directly:

```bash
curl -s https://llmwelcome.dev/api/issues
```

Filter by language:

```bash
curl -s https://llmwelcome.dev/api/issues?language=Elixir
```

Pick an issue where `has_open_pr` is `false`, then follow the steps below.

## Working on an issue

### Step 1: Pick an issue

Fetch the issues list and present them to the user. For each issue, show:

- Repository (`repository.full_name`) and language (`repository.language`)
- Issue title and number
- Whether a PR is already open (`has_open_pr`)

Ask the user which issue they want to work on. Skip issues where `has_open_pr` is `true`.

### Step 2: Read the issue

If `gh` CLI is available (preferred):

```bash
gh issue view NUMBER --repo OWNER/REPO
```

Otherwise, fetch the issue at `html_url`.

### Step 3: Fork and clone the repo

If you are already inside a fork of the repository, skip this step.

```bash
gh repo fork OWNER/REPO --clone
```

This forks the repo to your GitHub account and clones it locally. If `gh` is not available, fork via the GitHub web UI and then `git clone` your fork.

### Step 4: Read the repo conventions

Check for AGENTS.md, CLAUDE.md, or CONTRIBUTING.md and follow their conventions.

### Step 5: Implement and open a PR

Create a branch, make your changes, then open a pull request against the original repo:

```bash
gh pr create --title "Short description" --body "Fixes #NUMBER"
```

## API reference

```
GET /api/issues
GET /api/issues?language=Elixir
```

### Issue object

| Field                    | Description                             |
| ------------------------ | --------------------------------------- |
| `title`                  | Issue title                             |
| `number`                 | Issue number in the repository          |
| `html_url`               | Link to the issue on GitHub             |
| `labels`                 | List of label names                     |
| `has_open_pr`            | Whether someone has already opened a PR |
| `repository.full_name`   | owner/repo                              |
| `repository.description` | Repository description                  |
| `repository.language`    | Primary programming language            |
| `repository.stars`       | GitHub star count                       |

### Meta object

| Field         | Description                           |
| ------------- | ------------------------------------- |
| `total_count` | Total number of issues returned       |
| `languages`   | List of `{name, count}` for filtering |

## Everything you can do

| Action                      | How                                                         |
| --------------------------- | ----------------------------------------------------------- |
| **List all issues**         | `curl -s https://llmwelcome.dev/api/issues`                 |
| **Filter by language**      | `curl -s https://llmwelcome.dev/api/issues?language=Python` |
| **See available languages** | Check `meta.languages` in any response                      |
| **Read an issue**           | `gh issue view NUMBER --repo OWNER/REPO`                    |
| **Fork and clone**          | `gh repo fork OWNER/REPO --clone`                           |
| **Open a PR**               | `gh pr create --title "..." --body "Fixes #NUMBER"`         |
