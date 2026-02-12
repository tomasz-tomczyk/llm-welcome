---
name: prepare-for-llm-welcome
version: 0.1.0
description: Get your open source project ready for LLM-assisted contributions.
homepage: https://llmwelcome.dev
---

# Prepare your project for LLM Welcome

Get your open source project ready to receive high-quality contributions from LLM-assisted developers.

## What is LLM Welcome?

LLM Welcome is a curated directory of open source issues that maintainers have flagged as ready for LLM-assisted contributions. By preparing your project, you make it easy for AI-powered developers to find and work on your issues.

## Step 1: Install the GitHub App

Install the LLM Welcome GitHub App on your repository:

1. Go to https://github.com/apps/llm-welcome
2. Click "Install"
3. Select your repository

The app watches for issues with the `llm welcome` label and adds them to the directory.

> **Label variants:** The app accepts `llm welcome`, `llm-welcome`, and `llm_welcome` (case-insensitive). Use whichever form you prefer.

## Step 2: Add agent instructions to your repo

Create an `AGENTS.md` or `CLAUDE.md` file in your repository root with instructions for AI agents. Include:

- How to set up the development environment
- How to run tests
- Code style and conventions
- Any project-specific guidelines

Example:

```markdown
# Agent Instructions

## Setup

1. Install dependencies: `npm install`
2. Run tests: `npm test`
3. Start dev server: `npm run dev`

## Code Style

- Use TypeScript for all new files
- Follow existing patterns in the codebase
- Add tests for new functionality

## Pull Request Guidelines

- Keep PRs focused on a single issue
- Include tests
- Update documentation if needed
```

## Step 3: Label issues for LLM contributions

Add the `llm welcome` label to issues that are well-suited for LLM-assisted contributions. Good candidates are:

- **Well-defined scope**: Clear start and end points
- **Self-contained**: Minimal dependencies on other work
- **Good first issues**: Especially helpful for newcomers
- **Has context**: Enough information to understand the problem

## Step 4: Write clear issue descriptions

Help AI agents understand your issues by including:

- **Problem description**: What's wrong or what's needed
- **Expected behavior**: What success looks like
- **Relevant files**: Point to related code if helpful
- **Acceptance criteria**: How to verify the fix

Example issue template:

```markdown
## Problem

[Describe the issue]

## Expected Behavior

[What should happen instead]

## Relevant Files

- `src/components/Button.tsx`
- `src/styles/button.css`

## Acceptance Criteria

- [ ] Tests pass
- [ ] No regressions
- [ ] Documentation updated (if applicable)
```

## Best practices

| Practice                | Why                                            |
| ----------------------- | ---------------------------------------------- |
| **Keep issues focused** | Smaller, well-scoped issues get better results |
| **Provide context**     | Link to related issues, docs, or code          |
| **Update AGENTS.md**    | Keep setup instructions current                |
| **Review PRs promptly** | Encourages more contributions                  |
| **Give feedback**       | Help improve AI-assisted contributions         |

## Checklist

- [ ] GitHub App installed
- [ ] `AGENTS.md` or `CLAUDE.md` created
- [ ] `llm welcome` label created
- [ ] At least one issue labeled

Once you've completed these steps, your labeled issues will appear at https://llmwelcome.dev.
