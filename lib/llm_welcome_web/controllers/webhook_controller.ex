defmodule LlmWelcomeWeb.WebhookController do
  use LlmWelcomeWeb, :controller

  require Logger

  alias LlmWelcome.GitHub
  alias LlmWelcome.GitHub.API

  @llm_welcome_label "llm welcome"

  def github(conn, params) do
    event = get_req_header(conn, "x-github-event") |> List.first()
    action = params["action"]

    Logger.info("Webhook received: event=#{event} action=#{action}")

    handle_event(event, action, params)

    json(conn, %{ok: true})
  end

  # Installation events

  defp handle_event("installation", "created", %{
         "installation" => installation,
         "repositories" => repos
       }) do
    {:ok, inst} =
      GitHub.upsert_installation(%{
        github_installation_id: installation["id"],
        account_login: installation["account"]["login"],
        account_type: installation["account"]["type"]
      })

    Logger.info("Installation created: #{inst.account_login} (#{inst.github_installation_id})")

    sync_repos(inst, repos)
  end

  defp handle_event("installation", "deleted", %{"installation" => installation}) do
    case GitHub.mark_installation_deleted(installation["id"]) do
      {:ok, _} ->
        Logger.info("Installation deleted: #{installation["account"]["login"]}")

      {:error, :not_found} ->
        Logger.warning("Installation not found for deletion: #{installation["id"]}")
    end
  end

  # Issue events

  defp handle_event("issues", "labeled", %{
         "issue" => issue,
         "label" => label,
         "repository" => repo
       }) do
    if llm_welcome_label?(label["name"]) do
      case GitHub.get_repository_by_github_id(repo["id"]) do
        nil ->
          Logger.warning("Repository not found for issue label event: #{repo["full_name"]}")

        repository ->
          {:ok, _} =
            GitHub.upsert_issue(%{
              github_id: issue["id"],
              repository_id: repository.id,
              number: issue["number"],
              title: issue["title"],
              body: issue["body"],
              labels: issue["labels"],
              state: issue["state"],
              html_url: issue["html_url"]
            })

          Logger.info("Issue tracked: #{repo["full_name"]}##{issue["number"]}")
      end
    end
  end

  defp handle_event("issues", "unlabeled", %{"issue" => issue, "label" => label}) do
    if llm_welcome_label?(label["name"]) do
      case GitHub.delete_issue_by_github_id(issue["id"]) do
        {:ok, _} -> Logger.info("Issue untracked: ##{issue["number"]}")
        _ -> :ok
      end
    end
  end

  defp handle_event("issues", "closed", %{"issue" => issue}) do
    case GitHub.close_issue_by_github_id(issue["id"]) do
      {:ok, _} -> Logger.info("Issue closed: ##{issue["number"]}")
      {:error, :not_found} -> :ok
    end
  end

  defp handle_event("issues", "deleted", %{"issue" => issue}) do
    case GitHub.delete_issue_by_github_id(issue["id"]) do
      {:ok, _} -> Logger.info("Issue deleted: ##{issue["number"]}")
      _ -> :ok
    end
  end

  # Pull request events

  defp handle_event("pull_request", action, %{"pull_request" => pr, "repository" => repo})
       when action in ["opened", "reopened"] do
    case GitHub.get_repository_by_github_id(repo["id"]) do
      nil ->
        :ok

      repository ->
        for issue_number <- extract_linked_issue_numbers(pr["body"]) do
          GitHub.update_issue_has_open_pr(repository.id, issue_number, true)
        end
    end
  end

  defp handle_event("pull_request", "closed", %{"pull_request" => pr, "repository" => repo}) do
    case GitHub.get_repository_by_github_id(repo["id"]) do
      nil ->
        :ok

      repository ->
        merged? = pr["merged"] == true

        for issue_number <- extract_linked_issue_numbers(pr["body"]) do
          if merged? do
            GitHub.record_contribution(repository.id, issue_number, %{
              contributor: pr["user"]["login"],
              merged_pr_url: pr["html_url"],
              has_open_pr: false
            })

            Logger.info(
              "Contribution recorded: #{pr["user"]["login"]} merged PR for #{repo["full_name"]}##{issue_number}"
            )
          else
            GitHub.update_issue_has_open_pr(repository.id, issue_number, false)
          end
        end
    end
  end

  # Installation repository events (add/remove repos from existing installation)

  defp handle_event("installation_repositories", "added", %{
         "installation" => installation,
         "repositories_added" => repos
       }) do
    {:ok, inst} =
      GitHub.upsert_installation(%{
        github_installation_id: installation["id"],
        account_login: installation["account"]["login"],
        account_type: installation["account"]["type"]
      })

    sync_repos(inst, repos)
  end

  defp handle_event("installation_repositories", "removed", %{
         "repositories_removed" => repos
       }) do
    for repo <- repos do
      case GitHub.get_repository_by_github_id(repo["id"]) do
        nil -> :ok
        repository -> GitHub.delete_repository(repository)
      end
    end

    Logger.info("Removed #{length(repos)} repos from installation")
  end

  # Catch-all

  defp handle_event(event, action, _params) do
    Logger.debug("Unhandled webhook: event=#{event} action=#{action}")
  end

  # Helpers

  defp llm_welcome_label?(name) when is_binary(name) do
    name
    |> String.downcase()
    |> String.replace(~r/[-_]/, " ")
    |> String.trim()
    |> Kernel.==(@llm_welcome_label)
  end

  defp llm_welcome_label?(_), do: false

  defp sync_repos(installation, repos) when is_list(repos) do
    for repo <- repos do
      GitHub.upsert_repository(%{
        github_id: repo["id"],
        installation_id: installation.id,
        owner: repo["owner"]["login"] || installation.account_login,
        name: repo["name"],
        full_name: repo["full_name"],
        description: repo["description"],
        language: repo["language"],
        stars: repo["stargazers_count"] || 0
      })
    end

    Logger.info("Synced #{length(repos)} repos for #{installation.account_login}")
  end

  defp sync_repos(installation, _repos) do
    case API.list_installation_repos(installation.github_installation_id) do
      {:ok, repos} ->
        sync_repos(installation, repos)

      {:error, reason} ->
        Logger.error(
          "Failed to fetch repos for installation #{installation.github_installation_id}: #{inspect(reason)}"
        )
    end
  end

  defp extract_linked_issue_numbers(nil), do: []

  defp extract_linked_issue_numbers(body) do
    ~r/(?:close[sd]?|fix(?:e[sd])?|resolve[sd]?)\s+#(\d+)/i
    |> Regex.scan(body, capture: :all_but_first)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.uniq()
  end
end
