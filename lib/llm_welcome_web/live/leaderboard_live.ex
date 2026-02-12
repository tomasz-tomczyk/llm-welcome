defmodule LlmWelcomeWeb.LeaderboardLive do
  use LlmWelcomeWeb, :live_view

  alias LlmWelcome.GitHub

  @impl true
  def mount(_params, _session, socket) do
    contributors = GitHub.list_contributor_counts()

    socket =
      socket
      |> assign(:page_title, "Leaderboard")
      |> assign(
        :meta_description,
        "See who's contributing the most to open source with AI-assisted development. Ranked by number of merged LLM Welcome pull requests."
      )
      |> assign(:canonical_url, "https://llmwelcome.dev/leaderboard")
      |> assign(:contributors, contributors)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-2xl mx-auto">
        <div class="mb-6">
          <h1 class="text-lg font-semibold text-base-content">Leaderboard</h1>
          <p class="mt-1 text-sm text-base-content/70">
            Contributors ranked by number of merged
            <code class="badge badge-primary badge-outline font-mono px-1.5">
              llm-welcome
            </code>
            pull requests.
          </p>
        </div>

        <div :if={@contributors != []} class="space-y-2">
          <div
            :for={{contributor, count, rank} <- with_rank(@contributors)}
            class="flex items-center gap-4 rounded-lg border border-base-300 bg-base-100 px-4 py-3"
          >
            <span class={[
              "flex h-8 w-8 shrink-0 items-center justify-center rounded-full text-sm font-bold",
              rank_class(rank)
            ]}>
              {rank}
            </span>
            <a
              href={"https://github.com/#{contributor}"}
              target="_blank"
              rel="noopener"
              class="inline-flex min-w-0 flex-1 items-center gap-2 font-mono text-sm text-base-content hover:text-primary transition"
            >
              <svg class="size-4 shrink-0" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path
                  fill-rule="evenodd"
                  d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                  clip-rule="evenodd"
                />
              </svg>
              <span class="truncate">{contributor}</span>
            </a>
            <span class="shrink-0 rounded-full bg-primary/20 px-3 py-1 text-sm font-semibold text-primary">
              {count} {ngettext("PR", "PRs", count)}
            </span>
          </div>
        </div>

        <div :if={@contributors == []} class="py-20 text-center">
          <div class="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-full bg-base-200">
            <.icon name="hero-trophy" class="size-6 text-base-content/40" />
          </div>
          <p class="text-lg font-semibold text-base-content">No contributions yet</p>
          <p class="mt-2 text-sm text-base-content/60">
            Merged pull requests from LLM-assisted contributors will appear here.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp with_rank(contributors) do
    contributors
    |> Enum.with_index(1)
    |> Enum.map(fn {{contributor, count}, rank} -> {contributor, count, rank} end)
  end

  defp rank_class(1), do: "bg-primary/20 text-primary"
  defp rank_class(2), do: "bg-base-300/50 text-base-content/70"
  defp rank_class(3), do: "bg-base-300/30 text-base-content/60"
  defp rank_class(_), do: "bg-base-200 text-base-content/50"
end
