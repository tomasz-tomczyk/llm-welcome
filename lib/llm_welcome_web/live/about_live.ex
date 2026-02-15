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

        <h2>Get involved</h2>

        <p>
          <strong>Want to contribute?</strong>
          Browse the issues on the <.link navigate={~p"/"}>homepage</.link>
          or tell your AI assistant:
        </p>

        <.code_block
          id="about-find-issue"
          content="Read https://llmwelcome.dev/llm-welcome.skill.md and find me an issue to work on"
          pre_class="pr-8"
        />

        <p>
          <strong>Want to add your project?</strong>
          <a
            href="https://github.com/apps/llm-welcome"
            target="_blank"
            rel="noopener"
            class="not-prose inline-flex items-center gap-2 rounded-xl bg-primary px-2 py-2.5 text-sm font-semibold text-primary-content shadow transition hover:bg-primary/90 no-underline"
          >
            Install the GitHub App <.icon name="hero-arrow-up-right" class="size-4" />
          </a>
          and tell your AI assistant:
        </p>

        <.code_block
          id="about-prepare-project"
          content="Read https://llmwelcome.dev/prepare-for-llm-welcome.skill.md and prepare my project"
          pre_class="pr-8"
        />

        <h2>Protecting your project</h2>

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

        <h2>Open source</h2>

        <p>
          LLM Welcome is open source. You can find the code on <a
            href="https://github.com/tomasz-tomczyk/llm-welcome"
            target="_blank"
            rel="noopener"
          >GitHub</a>.
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
