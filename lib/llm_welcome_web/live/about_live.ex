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
          But there's a gap: most open source projects aren't set up to receive contributions from
          developers using these tools. And many developers who want to contribute to open source
          don't know where to start.
        </p>

        <p>
          LLM Welcome bridges this gap by:
        </p>

        <ul>
          <li>
            <strong>For contributors:</strong>
            Curating issues that are well-suited for AI-assisted development—clear scope, good
            context, and maintainers who are ready to review.
          </li>
          <li>
            <strong>For maintainers:</strong>
            Providing a way to signal that your project welcomes LLM-assisted contributions and
            helping you prepare your codebase with agent-friendly documentation.
          </li>
        </ul>

        <h2>How it works</h2>

        <p>
          Maintainers install the
          <a href="https://github.com/apps/llm-welcome" target="_blank" rel="noopener">
            LLM Welcome GitHub App
          </a>
          and add the <code>llm-welcome</code>
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

        <ul>
          <li>
            <strong>Well-defined scope:</strong> Clear start and end points
          </li>
          <li>
            <strong>Self-contained:</strong> Minimal dependencies on other work in progress
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
          Browse the issues on the <a href="/">homepage</a>
          or tell your AI assistant:
        </p>

        <pre><code>Read https://llmwelcome.dev/llm-welcome.skill.md and find me an issue to work on</code></pre>

        <p>
          <strong>Want to add your project?</strong>
          Install the GitHub App and tell your AI assistant:
        </p>

        <pre><code>Read https://llmwelcome.dev/prepare-for-llm-welcome.skill.md and prepare my project</code></pre>

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
