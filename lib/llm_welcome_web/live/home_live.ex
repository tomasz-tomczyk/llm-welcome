defmodule LlmWelcomeWeb.HomeLive do
  use LlmWelcomeWeb, :live_view

  alias LlmWelcome.GitHub

  @impl true
  def mount(_params, _session, socket) do
    agent_prompt =
      "Read https://llmwelcome.dev/llm-welcome.skill.md and find me an issue to work on"

    prepare_prompt =
      "Read https://llmwelcome.dev/prepare-for-llm-welcome.skill.md and prepare my project for LLM contributions"

    socket =
      socket
      |> assign(:page_title, "Find Open Source Issues")
      |> assign(
        :meta_description,
        "Browse open source issues ready for AI-assisted contributions. Find your next project to contribute to with Claude, Cursor, or Copilot."
      )
      |> assign(:canonical_url, "https://llmwelcome.dev")
      |> assign(:language_counts, GitHub.list_language_counts())
      |> assign(:total_issues, GitHub.count_open_issues())
      |> assign(:agent_prompt, agent_prompt)
      |> assign(:prepare_prompt, prepare_prompt)
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

  defp format_stars(stars) when stars >= 1000 do
    "#{Float.round(stars / 1000, 2)}K"
  end

  defp format_stars(stars), do: to_string(stars)

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="lg:grid lg:grid-cols-5 lg:gap-8">
        <aside class="lg:col-span-2 space-y-4">
          <div class="space-y-4 lg:sticky lg:top-8">
            <div>
              <span class="text-xs font-semibold uppercase tracking-[0.2em] text-base-content/50">
                About
              </span>
              <p class="mt-1 text-sm text-base-content/70">
                Make good use of your unused API tokens. Browse open source issues flagged by
                maintainers as ready for AI-assisted contributions and have your agent contribute to open source.
                <.link
                  navigate={~p"/about"}
                  class="font-semibold underline transition hover:text-base-content"
                >
                  Read more
                </.link>
              </p>
            </div>

            <a
              href="https://github.com/apps/llm-welcome"
              target="_blank"
              rel="noopener"
              class="flex w-full items-center justify-center gap-2 rounded-xl bg-primary px-4 py-2.5 text-sm font-semibold text-primary-content shadow transition hover:bg-primary/90"
            >
              Add LLM Welcome to your project <.icon name="hero-arrow-up-right" class="size-4" />
            </a>

            <div class="card bg-base-100/80 border border-base-300 shadow-sm backdrop-blur rounded-2xl">
              <div class="card-body p-4">
                <h2 class="card-title text-sm font-semibold text-base-content">
                  <.icon name="hero-command-line" class="size-5 text-primary" /> Find an issue
                </h2>
                <p class="text-sm text-base-content/70">
                  Tell your agent to fetch issues and start contributing.
                </p>
                <div class="mt-2">
                  <span class="text-xs font-semibold uppercase tracking-[0.2em] text-base-content/50">
                    Tell your agent
                  </span>
                  <pre class="mt-2 max-w-full whitespace-pre-wrap break-words rounded-xl border border-base-300 bg-neutral px-3 py-2 text-xs text-neutral-content shadow-inner"><code>{@agent_prompt}</code></pre>
                </div>
                <div class="card-actions justify-start mt-2">
                  <a
                    href="/llm-welcome.skill.md"
                    class="inline-flex items-center gap-1 text-xs font-semibold text-base-content/70 transition hover:text-base-content"
                  >
                    View the skill <.icon name="hero-arrow-up-right" class="size-3" />
                  </a>
                </div>
              </div>
            </div>

            <div class="card bg-base-100/80 border border-base-300 shadow-sm backdrop-blur rounded-2xl">
              <div class="card-body p-4">
                <h2 class="card-title text-sm font-semibold text-base-content">
                  <.icon name="hero-code-bracket-square" class="size-5 text-primary" />
                  Prepare your project
                </h2>
                <p class="text-sm text-base-content/70">
                  Get your open source project ready to receive LLM-assisted contributions.
                </p>
                <div class="mt-2">
                  <span class="text-xs font-semibold uppercase tracking-[0.2em] text-base-content/50">
                    Tell your agent
                  </span>
                  <pre class="mt-2 max-w-full whitespace-pre-wrap break-words rounded-xl border border-base-300 bg-neutral px-3 py-2 text-xs text-neutral-content shadow-inner"><code>{@prepare_prompt}</code></pre>
                </div>
                <div class="card-actions justify-start mt-2">
                  <a
                    href="/prepare-for-llm-welcome.skill.md"
                    class="inline-flex items-center gap-1 text-xs font-semibold text-base-content/70 transition hover:text-base-content"
                  >
                    View the skill <.icon name="hero-arrow-up-right" class="size-3" />
                  </a>
                </div>
              </div>
            </div>
          </div>
        </aside>

        <main class="lg:col-span-3 mt-8 lg:mt-0">
          <div :if={@language_counts != []} class="flex flex-wrap items-center gap-2 mb-4">
            <span class="text-xs font-semibold text-base-content/60">
              Filter
            </span>
            <button
              :for={{language, count} <- @language_counts}
              id={"language-#{language}"}
              phx-click="filter_language"
              phx-value-language={language}
              class={[
                "inline-flex items-center gap-2 rounded-full border px-3 py-1 text-xs font-semibold transition cursor-pointer",
                if(@selected_language == language,
                  do: "border-primary bg-primary text-primary-content shadow-sm",
                  else:
                    "border-base-300 bg-base-100 text-base-content/70 hover:border-base-content/40 hover:text-base-content"
                )
              ]}
            >
              {language}
              <span class="rounded-full bg-base-200 px-2 py-0.5 text-[10px] font-bold text-base-content/70">
                {count}
              </span>
            </button>
          </div>

          <div
            id="repositories"
            phx-update="stream"
            class="grid grid-cols-1 gap-3"
          >
            <details
              :for={{dom_id, repo} <- @streams.repositories}
              id={dom_id}
              name="repositories"
              class="group rounded-lg border border-base-300 bg-base-100 transition-colors open:border-primary/50"
            >
              <summary class="cursor-pointer list-none px-4 py-3 outline-none">
                <div class="flex items-start justify-between gap-4">
                  <div class="min-w-0 space-y-1">
                    <h2 class="font-mono">
                      <a
                        href={"https://github.com/#{repo.full_name}"}
                        target="_blank"
                        rel="noopener"
                        class="hover:underline"
                      >
                        {repo.owner} / <span class="text-primary">{repo.name}</span>
                      </a>
                    </h2>
                    <p :if={repo.description} class="text-sm text-base-content/80 line-clamp-2">
                      {repo.description}
                    </p>
                    <div class="flex flex-wrap items-center gap-x-4 gap-y-1 font-mono text-xs text-base-content/60">
                      <span :if={repo.language}>
                        language: <span class="text-primary">{repo.language}</span>
                      </span>
                      <span>
                        stars: <span class="text-primary">{format_stars(repo.stars)}</span>
                      </span>
                    </div>
                  </div>
                  <span class="shrink-0 rounded-full bg-primary/20 px-3 py-1 text-sm text-primary">
                    {length(repo.issues)} {ngettext("issue", "issues", length(repo.issues))}
                  </span>
                </div>
              </summary>

              <div class="border-t border-base-300 px-4 py-3">
                <ul class="space-y-1">
                  <li
                    :for={issue <- repo.issues}
                    class="flex items-center justify-between gap-4 py-1"
                  >
                    <a
                      href={issue.html_url}
                      target="_blank"
                      rel="noopener"
                      class="min-w-0 text-sm text-base-content/90 hover:text-primary"
                    >
                      <span class="text-base-content/50 font-mono">#{issue.number}</span>
                      <span class="ml-2">{issue.title}</span>
                    </a>
                    <div class="flex shrink-0 items-center gap-2 text-xs text-base-content/50">
                      <span
                        :if={issue.has_open_pr}
                        class="text-success"
                      >
                        PR open
                      </span>
                      <span class="inline-flex items-center gap-1">
                        <.icon name="hero-chat-bubble-left" class="size-3" />
                        {length(issue.labels)}
                      </span>
                    </div>
                  </li>
                </ul>
              </div>
            </details>
          </div>

          <div :if={@total_issues == 0} class="py-20 text-center">
            <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-full bg-base-200">
              <.icon name="hero-code-bracket" class="size-6 text-base-content/40" />
            </div>
            <p class="text-lg font-semibold text-base-content">No issues yet</p>
            <p class="mt-2 text-sm text-base-content/60">
              Install the GitHub App and add the
              <code class="rounded-full border border-base-300 bg-base-100 px-2 py-1 text-xs font-semibold text-base-content/70">
                llm welcome
              </code>
              label to your issues to get started.
            </p>
          </div>
        </main>
      </div>
    </Layouts.app>
    """
  end
end
