defmodule LlmWelcomeWeb.HomeLive do
  use LlmWelcomeWeb, :live_view

  alias LlmWelcome.GitHub

  @impl true
  def mount(_params, _session, socket) do
    api_snippet = "curl https://llmwelcome.dev/api/issues\ncurl https://llmwelcome.dev/api/issues?language=Elixir"
    skill_snippet = "curl -O https://llmwelcome.dev/llm-welcome.skill.md"

    socket =
      socket
      |> assign(:language_counts, GitHub.list_language_counts())
      |> assign(:total_issues, GitHub.count_open_issues())
      |> assign(:api_snippet, api_snippet)
      |> assign(:skill_snippet, skill_snippet)
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
    <section class="text-center mb-10">
      <h1 class="text-4xl sm:text-5xl font-extrabold tracking-tight mb-3">
        Find your first LLM contribution
      </h1>
      <p class="text-lg text-base-content/60 max-w-2xl mx-auto">
        Open source issues curated for LLM-assisted contributors.
        Pick one, fire up your agent, and ship.
      </p>
      <div :if={@total_issues > 0} class="mt-4">
        <span class="badge badge-primary badge-lg font-semibold">
          {@total_issues} open {ngettext("issue", "issues", @total_issues)}
        </span>
      </div>
    </section>

    <section class="mb-10 max-w-2xl mx-auto">
      <div class="card bg-base-200 border border-base-300">
        <div class="card-body gap-4">
          <h3 class="card-title text-lg">
            <.icon name="hero-command-line" class="size-5" /> For LLM Agents
          </h3>
          <p class="text-sm text-base-content/60">
            Discover issues programmatically via the JSON API or grab the skill file for your agent.
          </p>
          <div class="space-y-3">
            <div>
              <span class="text-xs font-semibold uppercase tracking-wider text-base-content/40">API</span>
              <pre class="mt-1 bg-base-300 rounded-lg px-4 py-3 text-sm overflow-x-auto"><code>{@api_snippet}</code></pre>
            </div>
            <div>
              <span class="text-xs font-semibold uppercase tracking-wider text-base-content/40">Skill file</span>
              <pre class="mt-1 bg-base-300 rounded-lg px-4 py-3 text-sm overflow-x-auto"><code>{@skill_snippet}</code></pre>
              <p class="mt-2 text-sm text-base-content/60">
                Or <a href={~p"/llm-welcome.skill.md"} class="link link-primary">view it in your browser</a> —
                step-by-step instructions for discovering and contributing to issues.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section
      :if={@language_counts != []}
      class="flex flex-wrap gap-2 justify-center mb-10"
    >
      <button
        :for={{language, count} <- @language_counts}
        phx-click="filter_language"
        phx-value-language={language}
        class={[
          "badge badge-lg cursor-pointer gap-1.5 transition-colors",
          if(@selected_language == language, do: "badge-primary", else: "badge-outline hover:badge-neutral")
        ]}
      >
        {language}
        <span class="opacity-60">{count}</span>
      </button>
    </section>

    <section
      id="repositories"
      phx-update="stream"
      class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5"
    >
      <article
        :for={{dom_id, repo} <- @streams.repositories}
        id={dom_id}
        class="card bg-base-200 shadow-sm hover:shadow-md transition-shadow border border-base-300"
      >
        <div class="card-body gap-3">
          <h2 class="card-title text-base">
            <a
              href={"https://github.com/#{repo.full_name}"}
              target="_blank"
              rel="noopener"
              class="link link-hover truncate"
            >
              <span class="text-base-content/50 font-normal">{repo.owner}/</span>{repo.name}
            </a>
          </h2>
          <p :if={repo.description} class="text-sm text-base-content/60 line-clamp-2">
            {repo.description}
          </p>
          <div class="card-actions items-center mt-auto pt-1 flex-wrap">
            <span :if={repo.language} class="badge badge-outline badge-sm">{repo.language}</span>
            <span class="badge badge-ghost badge-sm gap-1">
              <.icon name="hero-star-micro" class="size-3" /> {repo.stars}
            </span>
            <span class="badge badge-primary badge-sm">
              {repo.issue_count} {ngettext("issue", "issues", repo.issue_count)}
            </span>
          </div>
        </div>
      </article>
    </section>

    <section :if={@total_issues == 0} class="text-center py-20">
      <div class="text-5xl mb-4">
        <.icon name="hero-code-bracket" class="size-12 opacity-20" />
      </div>
      <p class="text-lg font-medium text-base-content/60">No issues yet</p>
      <p class="text-sm text-base-content/40 mt-1 max-w-md mx-auto">
        Install the GitHub App and add the
        <code class="badge badge-outline badge-sm align-middle">llm-welcome</code>
        label to your issues to get started.
      </p>
    </section>
    </Layouts.app>
    """
  end
end
