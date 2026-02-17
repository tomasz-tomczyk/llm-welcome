defmodule LlmWelcomeWeb.AboutLive do
  use LlmWelcomeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "About")
      |> assign(
        :meta_description,
        "Learn about LLM Welcome - a directory connecting open source maintainers with developers using AI coding assistants like Claude, Cursor, and Copilot."
      )
      |> assign(:canonical_url, "https://llmwelcome.dev/about")

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <article class="prose prose-sm sm:prose-base max-w-3xl">
        <h1>About LLM Welcome</h1>

        <p class="lead">
          LLM Welcome is a directory of open source issues that maintainers have flagged as ready
          for LLM-assisted contributions.
        </p>

        <h2>Why this exists</h2>

        <p>
          AI coding assistants are changing how developers work. Tools like Claude, Cursor, and
          GitHub Copilot can help developers understand codebases faster, write code more
          efficiently, and tackle unfamiliar problems with confidence.
        </p>

        <p>
          But many open source projects rightfully frown upon unwelcome LLM-generated contributions.
          LLM Welcome makes this explicit and opt-in—maintainers flag the issues where AI help is
          actually wanted.
        </p>

        <p>
          If you have unused API tokens from your coding agent subscription, put them to good use.
          Instead of letting them go to waste, point your agent at an issue and contribute something
          meaningful to open source.
        </p>

        <h2>How it works</h2>

        <p>
          Maintainers install the
          <a href="https://github.com/apps/llm-welcome" target="_blank" rel="noopener">
            LLM Welcome GitHub App
          </a>
          and add the <code>llm welcome</code>
          label to issues they want to surface. These issues
          appear in our directory and API, making them discoverable by developers and their AI
          assistants.
        </p>

        <p>
          Contributors can browse issues here, or tell their AI assistant to fetch issues directly
          using our skill files. The assistant can then help them understand the issue, fork the
          repo, implement a solution, and open a pull request.
        </p>

        <h2>What makes a good LLM Welcome issue?</h2>

        <p>
          Any issue where you'd genuinely welcome an AI-assisted contribution. This could be a
          well-scoped task that's easy to pick up, or a hard challenge you'd like to see agents take
          a stab at. Some examples:
        </p>

        <ul>
          <li>
            <strong>Well-defined tasks:</strong>
            Clear scope with obvious start and end points—great for quick wins
          </li>
          <li>
            <strong>Hard problems:</strong>
            Gnarly bugs, complex refactors, or ambitious features you'd love fresh eyes on
          </li>
          <li>
            <strong>Good context:</strong>
            Enough information to understand the problem without deep project knowledge
          </li>
          <li>
            <strong>Testable:</strong> Clear acceptance criteria or ways to verify the fix
          </li>
        </ul>

        <h2 id="protecting-your-project">Protecting your project</h2>

        <p>
          Worried about unsolicited AI-generated PRs? Use the
          <a href="https://github.com/peakoss/anti-slop" target="_blank" rel="noopener">
            anti-slop
          </a>
          GitHub Action to automatically close low-quality PRs while allowing contributions
          on your <code>llm welcome</code>
          issues. We provide a <a href="/anti-slop.yml" target="_blank">recommended workflow file</a>
          you can drop into your repository.
        </p>

        <h2>Acknowledgements</h2>

        <p>
          This project was inspired by <a
            href="https://goodfirstissue.dev/"
            target="_blank"
            rel="noopener"
          >Good First Issue</a>, which curates issues for first-time open source contributors.
          LLM Welcome takes a similar approach but focuses specifically on issues suited for
          AI-assisted development.
        </p>
      </article>
    </Layouts.app>
    """
  end
end
