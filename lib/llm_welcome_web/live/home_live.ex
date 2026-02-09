defmodule LlmWelcomeWeb.HomeLive do
  use LlmWelcomeWeb, :live_view

  alias LlmWelcome.GitHub

  @impl true
  def mount(_params, _session, socket) do
    api_snippet = "curl -s https://llmwelcome.dev/api/issues"

    agent_prompt =
      "Read https://llmwelcome.dev/llm-welcome.skill.md and find me an issue to work on"

    socket =
      socket
      |> assign(:language_counts, GitHub.list_language_counts())
      |> assign(:total_issues, GitHub.count_open_issues())
      |> assign(:api_snippet, api_snippet)
      |> assign(:agent_prompt, agent_prompt)
      |> stream(:repositories, [])

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    language = params["language"]
    repos = GitHub.list_repositories_with_issues(language: language)

    socket =
      socket
      |> assign(:selected_language, language)
      |> stream(:repositories, repos, reset: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("filter_language", %{"language" => language}, socket) do
    params =
      if language == socket.assigns.selected_language,
        do: %{},
        else: %{language: language}

    {:noreply, push_patch(socket, to: ~p"/?#{params}")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <section class="grid gap-8 lg:grid-cols-[minmax(0,1fr)_360px] lg:gap-14 lg:items-center">
        <div class="space-y-5 lg:pr-6">
          <div class="inline-flex items-center gap-2 rounded-full border border-base-300 bg-base-100/80 px-3 py-1 text-xs font-semibold uppercase tracking-[0.2em] text-primary shadow-sm">
            Built for agent workflows
          </div>
          <h1 class="font-display text-4xl leading-tight sm:text-5xl lg:text-6xl">
            Find your first
            <span class="bg-gradient-to-r from-primary via-secondary to-accent bg-clip-text text-transparent">
              LLM-powered
            </span>
            contribution
          </h1>
          <p class="text-lg text-base-content/70 sm:text-xl">
            A curated directory of open source issues that are perfect for AI-assisted contributors.
            Pick a project, expand the issue list, and ship with confidence.
          </p>
          <div class="flex flex-wrap items-center gap-3">
            <div
              :if={@total_issues > 0}
              class="rounded-full border border-base-300 bg-base-100 px-4 py-2 text-sm font-semibold text-base-content shadow-sm"
            >
              {@total_issues} open {ngettext("issue", "issues", @total_issues)}
            </div>
            <a
              href="/llm-welcome.skill.md"
              class="inline-flex items-center gap-2 text-sm font-semibold text-base-content/80 transition hover:text-base-content"
            >
              View the agent skill
              <.icon name="hero-arrow-up-right" class="size-4" />
            </a>
          </div>
        </div>

        <div class="rounded-3xl border border-base-300 bg-base-100/80 p-4 shadow-[0_20px_60px_-40px_rgba(15,23,42,0.6)] backdrop-blur sm:p-6 lg:justify-self-end lg:w-full lg:max-w-sm">
          <div class="flex items-center gap-2 text-sm font-semibold text-base-content">
            <.icon name="hero-command-line" class="size-5 text-primary" />
            Get your agent started
          </div>
          <p class="mt-2 text-sm text-base-content/70">
            Drop a prompt or curl snippet into your workflow to surface the latest issues.
          </p>
          <div class="mt-4 space-y-4">
            <div>
              <span class="text-xs font-semibold uppercase tracking-[0.2em] text-base-content/50">
                Tell your agent
              </span>
              <pre class="mt-2 max-w-full whitespace-pre-wrap break-words rounded-2xl border border-base-300 bg-neutral px-4 py-3 text-sm text-neutral-content shadow-inner"><code>{@agent_prompt}</code></pre>
            </div>
            <div>
              <span class="text-xs font-semibold uppercase tracking-[0.2em] text-base-content/50">
                Use the API directly
              </span>
              <pre class="mt-2 max-w-full whitespace-pre-wrap break-words rounded-2xl border border-base-300 bg-neutral px-4 py-3 text-sm text-neutral-content shadow-inner"><code>{@api_snippet}</code></pre>
            </div>
          </div>
        </div>
      </section>

      <section :if={@language_counts != []} class="mt-10 flex flex-wrap items-center gap-2">
        <span class="text-xs font-semibold text-base-content/60">
          Filter by language
        </span>
        <button
          :for={{language, count} <- @language_counts}
          id={"language-#{language}"}
          phx-click="filter_language"
          phx-value-language={language}
          class={[
            "inline-flex items-center gap-2 rounded-full border px-3 py-1 text-xs font-semibold transition cursor-pointer",
            if(@selected_language == language,
              do: "border-neutral bg-neutral text-neutral-content shadow-sm",
              else: "border-base-300 bg-base-100 text-base-content/70 hover:border-base-content/40 hover:text-base-content"
            )
          ]}
        >
          {language}
          <span class="rounded-full bg-base-200 px-2 py-0.5 text-[10px] font-bold text-base-content/70">
            {count}
          </span>
        </button>
      </section>

      <section
        id="repositories"
        phx-update="stream"
        class="mt-8 grid grid-cols-1 gap-4 lg:gap-6"
      >
        <details
          :for={{dom_id, repo} <- @streams.repositories}
          id={dom_id}
          class="group rounded-2xl border border-base-300 bg-base-100/80 shadow-[0_14px_40px_-38px_rgba(15,23,42,0.6)] transition hover:shadow-[0_22px_50px_-40px_rgba(15,23,42,0.7)]"
        >
          <summary class="cursor-pointer list-none px-3 py-3 outline-none sm:px-5 sm:py-4">
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
              <div class="min-w-0 space-y-1">
                <h2 class="font-display text-lg font-semibold text-base-content">
                  <a
                    href={"https://github.com/#{repo.full_name}"}
                    target="_blank"
                    rel="noopener"
                    class="block max-w-full cursor-pointer truncate transition hover:text-primary"
                  >
                    <span class="text-base-content/40">{repo.owner}/</span>{repo.name}
                  </a>
                </h2>
                <p :if={repo.description} class="max-w-2xl text-sm text-base-content/70 line-clamp-1">
                  {repo.description}
                </p>
                <div class="flex flex-wrap items-center gap-2 text-xs font-semibold text-base-content/60">
                  <span :if={repo.language} class="rounded-full border border-base-300 bg-base-100 px-2.5 py-1">
                    {repo.language}
                  </span>
                  <span class="inline-flex items-center gap-1 rounded-full border border-base-300 bg-base-100 px-2.5 py-1">
                    <.icon name="hero-star" class="size-3 text-primary" />
                    {repo.stars}
                  </span>
                  <span class="inline-flex items-center gap-1 rounded-full border border-primary/30 bg-primary/10 px-2.5 py-1 text-primary">
                    {length(repo.issues)} {ngettext("issue", "issues", length(repo.issues))}
                  </span>
                </div>
              </div>
              <div class="hidden items-center gap-2 text-xs font-semibold text-base-content/60 sm:flex">
                <span class="inline-flex items-center gap-1 rounded-full border border-primary/30 bg-primary/10 px-2.5 py-1 text-primary">
                  {length(repo.issues)} {ngettext("issue", "issues", length(repo.issues))}
                </span>
                <.icon name="hero-chevron-down" class="size-4 transition group-open:rotate-180" />
              </div>
            </div>
          </summary>

          <div class="border-t border-base-300 px-4 pb-4 pt-4 sm:px-5">
            <ul class="space-y-3">
              <li :for={issue <- repo.issues} class="rounded-2xl border border-base-300 bg-base-100 px-4 py-3 shadow-sm">
                <div class="flex flex-wrap items-start justify-between gap-3">
                  <div class="space-y-2">
                    <a
                      href={issue.html_url}
                      target="_blank"
                      rel="noopener"
                      class="cursor-pointer text-sm font-semibold text-base-content transition hover:text-primary"
                    >
                      #{issue.number} {issue.title}
                    </a>
                    <div class="flex flex-wrap items-center gap-2 text-[11px] font-semibold text-base-content/50">
                      <span :if={issue.has_open_pr} class="rounded-full border border-success/30 bg-success/10 px-2 py-1 text-success">
                        PR open
                      </span>
                      <span
                        :for={label <- Enum.take(issue.labels, 3)}
                        class="rounded-full border border-base-300 bg-base-200 px-2 py-1 text-base-content/70"
                      >
                        {label["name"]}
                      </span>
                    </div>
                  </div>
                  <a
                    href={issue.html_url}
                    target="_blank"
                    rel="noopener"
                    class="cursor-pointer inline-flex items-center gap-1 rounded-full border border-base-300 bg-base-100 px-3 py-1 text-xs font-semibold text-base-content/70 transition hover:border-base-content/40 hover:text-base-content"
                  >
                    Open issue
                    <.icon name="hero-arrow-up-right" class="size-3" />
                  </a>
                </div>
              </li>
            </ul>
          </div>
        </details>
      </section>

      <section :if={@total_issues == 0} class="py-20 text-center">
        <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-full bg-base-200">
          <.icon name="hero-code-bracket" class="size-6 text-base-content/40" />
        </div>
        <p class="text-lg font-semibold text-base-content">No issues yet</p>
        <p class="mt-2 text-sm text-base-content/60">
          Install the GitHub App and add the
          <code class="rounded-full border border-base-300 bg-base-100 px-2 py-1 text-xs font-semibold text-base-content/70">
            llm-welcome
          </code>
          label to your issues to get started.
        </p>
      </section>
    </Layouts.app>
    """
  end
end
