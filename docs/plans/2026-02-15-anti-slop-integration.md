# Anti-Slop Integration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Give maintainers a drop-in workflow to block unsolicited AI PRs while allowing contributions on `llm welcome` issues.

**Architecture:** A static workflow YAML file served from the repo, referenced by the prepare-for-llm-welcome skill and the About page. No backend changes.

**Tech Stack:** GitHub Actions (anti-slop), Phoenix LiveView (about page), Markdown (skill file)

---

### Task 1: Create the recommended workflow file

**Files:**
- Create: `priv/static/anti-slop.yml`

**Step 1: Create the workflow file**

```yaml
# Save this file to .github/workflows/anti-slop.yml in your repository
#
# This workflow uses the anti-slop GitHub Action to automatically close
# low-quality and unsolicited AI-generated pull requests, while allowing
# contributions on issues labeled "llm welcome".
#
# Learn more: https://llmwelcome.dev/about
# Anti-slop docs: https://github.com/peakoss/anti-slop

name: Anti-Slop

on:
  pull_request_target:
    types: [opened, reopened]

permissions:
  contents: read
  issues: read
  pull-requests: write

jobs:
  anti-slop:
    runs-on: ubuntu-latest
    steps:
      - uses: peakoss/anti-slop@v1
        with:
          exempt-label: "llm welcome"
          require-linked-issue: true
          close-pr: true
          failure-pr-message: |
            Thanks for your interest in contributing! This PR was automatically
            closed because it doesn't appear to be linked to an approved issue.

            This project uses [LLM Welcome](https://llmwelcome.dev) to manage
            AI-assisted contributions. If you'd like to contribute using AI tools,
            please look for issues labeled `llm welcome` in this repository.

            Browse available issues at https://llmwelcome.dev
```

**Step 2: Verify the file renders correctly**

Run: `cat priv/static/anti-slop.yml`
Expected: Valid YAML, readable comments, clear message.

**Step 3: Commit**

```bash
git add priv/static/anti-slop.yml
git commit -m "Add recommended anti-slop workflow file for maintainers"
```

---

### Task 2: Update the prepare-for-llm-welcome skill

**Files:**
- Modify: `prepare-for-llm-welcome.skill.md` (after line 100, before "Best practices")

**Step 1: Add Step 5 to the skill file**

Insert after the Step 4 section (line 100) and before "Best practices" (line 102):

```markdown
## Step 5: Protect against unwanted AI PRs (optional)

Use the [anti-slop](https://github.com/peakoss/anti-slop) GitHub Action to automatically close low-quality or unsolicited AI-generated PRs while allowing contributions on your `llm welcome` issues.

1. Download the recommended workflow: https://llmwelcome.dev/anti-slop.yml
2. Save it to `.github/workflows/anti-slop.yml` in your repository
3. Commit and push

The workflow auto-exempts repository owners, members, and collaborators. PRs linked to issues labeled `llm welcome` are also exempt.

> **Customization:** See the [anti-slop documentation](https://github.com/peakoss/anti-slop) for all 44 configuration options, including account age requirements, merge ratio thresholds, and blocked file paths.
```

**Step 2: Update the checklist**

Add to the checklist at the bottom:

```markdown
- [ ] (Optional) Anti-slop workflow added
```

**Step 3: Commit**

```bash
git add prepare-for-llm-welcome.skill.md
git commit -m "Add anti-slop setup to prepare-for-llm-welcome skill"
```

---

### Task 3: Update the About page

**Files:**
- Modify: `lib/llm_welcome_web/live/about_live.ex:126-127` (insert new section between "Get involved" code block and "Open source")

**Step 1: Add the "Protecting your project" section**

Insert after the `about-prepare-project` code block (line 126) and before the "Open source" `<h2>` (line 128):

```heex
        <h2>Protecting your project</h2>

        <p>
          Worried about unsolicited AI-generated PRs? Use the
          <a href="https://github.com/peakoss/anti-slop" target="_blank" rel="noopener">
            anti-slop
          </a>
          GitHub Action to automatically close low-quality PRs while allowing contributions
          on your <code>llm welcome</code> issues. We provide a
          <a href="/anti-slop.yml" target="_blank">recommended workflow file</a>
          you can drop into your repository.
        </p>
```

**Step 2: Verify the page compiles**

Run: `mix compile --warnings-as-errors`
Expected: Compilation success, no warnings.

**Step 3: Commit**

```bash
git add lib/llm_welcome_web/live/about_live.ex
git commit -m "Add anti-slop section to About page"
```

---

### Task 4: Verify everything works

**Step 1: Run the full test suite**

Run: `mix test`
Expected: All tests pass.

**Step 2: Run the linter**

Run: `mix format --check-formatted`
Expected: No formatting issues.

**Step 3: Verify the static file is accessible**

Run: `mix phx.server` then `curl http://localhost:4000/anti-slop.yml`
Expected: The YAML workflow file content is returned.

**Step 4: Visually check the About page**

Visit `http://localhost:4000/about` and confirm the new "Protecting your project" section appears between "Get involved" and "Open source".

**Step 5: Final commit if any formatting was needed**

```bash
git add -A
git commit -m "Fix formatting"
```
