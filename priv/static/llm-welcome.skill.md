# LLM Welcome - Issue Discovery Skill

Use this skill to find open-source issues that maintainers have flagged as suitable for LLM-assisted contributions.

## Discovering issues

Fetch issues from the public API:

```bash
curl https://llmwelcome.dev/api/issues
```

Filter by programming language:

```bash
curl https://llmwelcome.dev/api/issues?language=Python
```

The response includes an `issues` array and a `meta` object with available languages and counts.

## Working on an issue

1. Pick an issue from the API response where `has_open_pr` is `false`.
2. Read the full issue details. If `gh` CLI is available, prefer it over fetching the URL:
   ```bash
   gh issue view NUMBER --repo OWNER/REPO
   ```
   Otherwise, read the issue at `html_url`.
3. If the repository is not already cloned locally, clone it:
   ```bash
   gh repo clone OWNER/REPO   # if gh is available
   git clone https://github.com/OWNER/REPO.git
   ```
   If you are already inside the repository, skip this step.
4. Read the repository's AGENTS.md, CLAUDE.md, or CONTRIBUTING.md if present - these contain project-specific conventions.
5. Implement the fix or feature on a new branch.
6. Open a pull request that references the issue:
   ```bash
   gh pr create --title "Fix: short description" --body "Fixes #NUMBER"
   ```

## Response schema

Each issue contains:
- `title` - issue title
- `number` - issue number in the repository
- `html_url` - link to the issue on GitHub
- `labels` - list of label names
- `has_open_pr` - whether someone has already opened a PR for this issue
- `repository.full_name` - owner/repo identifier
- `repository.description` - repository description
- `repository.language` - primary programming language
- `repository.stars` - GitHub star count

## Tips

- Prefer issues where `has_open_pr` is `false` to avoid duplicating work.
- Use `meta.languages` to find issues in languages you can work with.
- Always follow the contributing guidelines of the target repository.
