# Anti-Slop Integration for LLM Welcome

## Problem

Open source maintainers who use LLM Welcome want to accept AI-assisted PRs on curated issues while blocking unsolicited AI-generated PRs. There's no turnkey solution for this. The existing [anti-slop](https://github.com/peakoss/anti-slop) GitHub Action detects and closes low-quality/AI PRs but needs to be configured specifically for the llm-welcome workflow.

## Solution

Provide a pre-configured anti-slop workflow file and documentation that maintainers can drop into their repos. PRs linked to `llm welcome` issues are exempt; everything else goes through anti-slop's checks.

## Deliverables

### 1. Recommended workflow file

A ready-to-copy GitHub Actions workflow using anti-slop with these settings:

| Setting | Value | Rationale |
|---------|-------|-----------|
| `exempt-label` | `llm welcome` | PRs on curated issues pass through |
| `close-pr` | `true` | Auto-close detected slop |
| `failure-pr-message` | Custom message pointing to llmwelcome.dev | Redirect contributors to curated issues |
| `require-linked-issue` | `true` | Forces PRs to reference an issue |
| `min-account-age` | `7` | Filters throwaway accounts |
| `min-global-merge-ratio` | `30` | Filters accounts with bad track records |

The file lives at a path in the repo that the skill and about page can reference.

### 2. Update `prepare-for-llm-welcome.skill.md`

Add a new "Step 5: Protect against unwanted AI PRs" section that explains how to add the anti-slop workflow.

### 3. Update the About page

Add a section for maintainers about protecting their repos from unsolicited AI PRs using anti-slop.

## What we're NOT building

- No new GitHub Action
- No llmwelcome.dev API changes
- No changes to the GitHub App

## Prior art

- [anti-slop](https://github.com/peakoss/anti-slop) - 22 check rules, 44 configurable options, auto-exempts repo members
- [Fingerprinting AI Coding Agents](https://arxiv.org/html/2601.17406) - 97.2% F1-score detecting AI agents via metadata
- [GitHub community discussion](https://github.com/orgs/community/discussions/159749) - Maintainers requesting native tools for this
