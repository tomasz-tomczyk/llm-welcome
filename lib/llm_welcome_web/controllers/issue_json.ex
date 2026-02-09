defmodule LlmWelcomeWeb.IssueJSON do
  alias LlmWelcome.GitHub.Issue

  def index(%{issues: issues, language_counts: language_counts}) do
    %{
      issues: Enum.map(issues, &issue_data/1),
      meta: %{
        total_count: length(issues),
        languages: Enum.map(language_counts, fn {name, count} -> %{name: name, count: count} end)
      }
    }
  end

  defp issue_data(%Issue{repository: repo} = issue) do
    %{
      title: issue.title,
      number: issue.number,
      html_url: issue.html_url,
      labels: Enum.map(issue.labels, & &1["name"]),
      has_open_pr: issue.has_open_pr,
      repository: %{
        full_name: repo.full_name,
        description: repo.description,
        language: repo.language,
        stars: repo.stars
      }
    }
  end
end
