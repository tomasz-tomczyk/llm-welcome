defmodule LlmWelcomeWeb.IssueController do
  use LlmWelcomeWeb, :controller

  alias LlmWelcome.GitHub

  def index(conn, params) do
    opts = if params["language"], do: [language: params["language"]], else: []
    issues = GitHub.list_open_issues(opts)
    language_counts = GitHub.list_language_counts()

    render(conn, :index, issues: issues, language_counts: language_counts)
  end
end
