# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Idempotent — safe to run multiple times thanks to upsert functions.

alias LlmWelcome.GitHub

# --- Installations ---

{:ok, elixir_org} =
  GitHub.upsert_installation(%{
    github_installation_id: 90_000_001,
    account_login: "elixir-lang",
    account_type: "Organization"
  })

{:ok, phoenix_org} =
  GitHub.upsert_installation(%{
    github_installation_id: 90_000_002,
    account_login: "phoenixframework",
    account_type: "Organization"
  })

{:ok, rustlang_org} =
  GitHub.upsert_installation(%{
    github_installation_id: 90_000_003,
    account_login: "rust-lang",
    account_type: "Organization"
  })

{:ok, user_install} =
  GitHub.upsert_installation(%{
    github_installation_id: 90_000_004,
    account_login: "samdev",
    account_type: "User"
  })

# --- Repositories ---

{:ok, elixir_repo} =
  GitHub.upsert_repository(%{
    github_id: 80_000_001,
    installation_id: elixir_org.id,
    owner: "elixir-lang",
    name: "elixir",
    full_name: "elixir-lang/elixir",
    description: "Elixir is a dynamic, functional language for building scalable applications",
    language: "Elixir",
    stars: 24_600
  })

{:ok, phoenix_repo} =
  GitHub.upsert_repository(%{
    github_id: 80_000_002,
    installation_id: phoenix_org.id,
    owner: "phoenixframework",
    name: "phoenix",
    full_name: "phoenixframework/phoenix",
    description: "Peace of mind from prototype to production",
    language: "Elixir",
    stars: 21_800
  })

{:ok, liveview_repo} =
  GitHub.upsert_repository(%{
    github_id: 80_000_003,
    installation_id: phoenix_org.id,
    owner: "phoenixframework",
    name: "phoenix_live_view",
    full_name: "phoenixframework/phoenix_live_view",
    description: "Rich, real-time user experiences with server-rendered HTML",
    language: "Elixir",
    stars: 6_300
  })

{:ok, rustlings_repo} =
  GitHub.upsert_repository(%{
    github_id: 80_000_004,
    installation_id: rustlang_org.id,
    owner: "rust-lang",
    name: "rustlings",
    full_name: "rust-lang/rustlings",
    description: "Small exercises to get you used to reading and writing Rust code",
    language: "Rust",
    stars: 55_000
  })

{:ok, cargo_repo} =
  GitHub.upsert_repository(%{
    github_id: 80_000_005,
    installation_id: rustlang_org.id,
    owner: "rust-lang",
    name: "cargo",
    full_name: "rust-lang/cargo",
    description: "The Rust package manager",
    language: "Rust",
    stars: 13_200
  })

{:ok, samdev_repo} =
  GitHub.upsert_repository(%{
    github_id: 80_000_006,
    installation_id: user_install.id,
    owner: "samdev",
    name: "todo-cli",
    full_name: "samdev/todo-cli",
    description: "A simple CLI task manager written in Python",
    language: "Python",
    stars: 42
  })

{:ok, js_repo} =
  GitHub.upsert_repository(%{
    github_id: 80_000_007,
    installation_id: user_install.id,
    owner: "samdev",
    name: "react-hooks-lib",
    full_name: "samdev/react-hooks-lib",
    description: "Collection of useful React hooks",
    language: "JavaScript",
    stars: 310
  })

# --- Issues: Open, available for LLM contribution ---

llm_welcome_label = %{"id" => 1, "name" => "llm-welcome", "color" => "0e8a16"}
bug_label = %{"id" => 2, "name" => "bug", "color" => "d73a4a"}
docs_label = %{"id" => 3, "name" => "documentation", "color" => "0075ca"}
enhancement_label = %{"id" => 4, "name" => "enhancement", "color" => "a2eeef"}
good_first_label = %{"id" => 5, "name" => "good first issue", "color" => "7057ff"}

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_001,
    repository_id: elixir_repo.id,
    number: 101,
    title: "Add @moduledoc false to internal helper modules",
    body: """
    Several internal helper modules are missing `@moduledoc false`, which causes them \
    to appear in the generated documentation. An LLM agent should be able to scan for \
    these and add the missing attribute.
    """,
    labels: [llm_welcome_label, docs_label],
    state: "open",
    html_url: "https://github.com/elixir-lang/elixir/issues/101"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_002,
    repository_id: phoenix_repo.id,
    number: 250,
    title: "Fix typos in Channels guide",
    body: """
    The Channels guide has a few typos and outdated code samples. \
    This is a great issue for an LLM-assisted contributor to fix.
    """,
    labels: [llm_welcome_label, docs_label, good_first_label],
    state: "open",
    html_url: "https://github.com/phoenixframework/phoenix/issues/250"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_003,
    repository_id: phoenix_repo.id,
    number: 251,
    title: "Add missing pattern match examples to router docs",
    body: """
    The router documentation could use more examples showing pattern matching \
    in plug pipelines. Well-scoped for a quick contribution.
    """,
    labels: [llm_welcome_label, enhancement_label],
    state: "open",
    html_url: "https://github.com/phoenixframework/phoenix/issues/251"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_004,
    repository_id: liveview_repo.id,
    number: 88,
    title: "Improve error message for missing phx-target",
    body: """
    When a LiveView event is sent without a `phx-target` and the component \
    can't be found, the error message is confusing. Improve it to suggest \
    adding `phx-target`.
    """,
    labels: [llm_welcome_label, bug_label],
    state: "open",
    html_url: "https://github.com/phoenixframework/phoenix_live_view/issues/88"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_005,
    repository_id: rustlings_repo.id,
    number: 512,
    title: "Add hint for quiz3.rs exercise",
    body: """
    The quiz3 exercise has no hint, which makes it harder than intended. \
    Add a helpful hint similar to other quiz exercises.
    """,
    labels: [llm_welcome_label, good_first_label],
    state: "open",
    html_url: "https://github.com/rust-lang/rustlings/issues/512"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_006,
    repository_id: cargo_repo.id,
    number: 1042,
    title: "Clarify error message for cyclic dependencies",
    body: """
    When cargo detects a cyclic dependency, the error message doesn't clearly \
    indicate which crates form the cycle. Improve the message to list the full \
    dependency chain.
    """,
    labels: [llm_welcome_label, enhancement_label],
    state: "open",
    html_url: "https://github.com/rust-lang/cargo/issues/1042"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_007,
    repository_id: samdev_repo.id,
    number: 5,
    title: "Add --json flag to list command",
    body: """
    The `list` command currently only outputs plain text. Adding a `--json` flag \
    would make it easier to pipe output into other tools.
    """,
    labels: [llm_welcome_label, enhancement_label],
    state: "open",
    html_url: "https://github.com/samdev/todo-cli/issues/5"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_008,
    repository_id: samdev_repo.id,
    number: 7,
    title: "Fix crash when config file is missing",
    body: """
    Running any command without `~/.todo.json` causes an unhandled FileNotFoundError. \
    Should create a default config instead.
    """,
    labels: [llm_welcome_label, bug_label],
    state: "open",
    html_url: "https://github.com/samdev/todo-cli/issues/7"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_009,
    repository_id: js_repo.id,
    number: 23,
    title: "Add useLocalStorage hook",
    body: """
    A `useLocalStorage` hook that syncs state to `localStorage` with SSR safety \
    would be a useful addition. Should handle serialization/deserialization \
    and storage events from other tabs.
    """,
    labels: [llm_welcome_label, enhancement_label],
    state: "open",
    html_url: "https://github.com/samdev/react-hooks-lib/issues/23"
  })

# --- Issue: Open with an active PR ---

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_010,
    repository_id: js_repo.id,
    number: 21,
    title: "Add useDebounce hook",
    body: "A debounce hook for handling rapid input changes.",
    labels: [llm_welcome_label, enhancement_label],
    state: "open",
    has_open_pr: true,
    html_url: "https://github.com/samdev/react-hooks-lib/issues/21"
  })

# --- Issues: Closed / completed by LLM contributors ---

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_011,
    repository_id: elixir_repo.id,
    number: 95,
    title: "Fix broken link in String module docs",
    body: "The `String.split/3` docs link to a non-existent anchor.",
    labels: [llm_welcome_label, docs_label],
    state: "closed",
    contributor: "llm-bot-42",
    merged_pr_url: "https://github.com/elixir-lang/elixir/pull/96",
    html_url: "https://github.com/elixir-lang/elixir/issues/95"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_012,
    repository_id: rustlings_repo.id,
    number: 480,
    title: "Fix incorrect expected output in strings2 exercise",
    body: "The expected output doesn't match the exercise description.",
    labels: [llm_welcome_label, bug_label],
    state: "closed",
    contributor: "claude-contributor",
    merged_pr_url: "https://github.com/rust-lang/rustlings/pull/481",
    html_url: "https://github.com/rust-lang/rustlings/issues/480"
  })

{:ok, _} =
  GitHub.upsert_issue(%{
    github_id: 70_000_013,
    repository_id: samdev_repo.id,
    number: 3,
    title: "Add tab completion for bash",
    body: "Would be nice to have bash completion for the CLI commands.",
    labels: [llm_welcome_label, enhancement_label],
    state: "closed",
    contributor: "gpt-helper",
    merged_pr_url: "https://github.com/samdev/todo-cli/pull/4",
    html_url: "https://github.com/samdev/todo-cli/issues/3"
  })

IO.puts("""
Seeds complete!
  4 installations
  7 repositories (Elixir, Rust, Python, JavaScript)
  13 issues (9 open, 1 with active PR, 3 closed with contributions)
""")
