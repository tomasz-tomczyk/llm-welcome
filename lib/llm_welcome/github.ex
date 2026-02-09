defmodule LlmWelcome.GitHub do
  import Ecto.Query

  alias LlmWelcome.Repo
  alias LlmWelcome.GitHub.{Installation, Repository, Issue}

  # Directory queries

  def list_language_counts do
    from(r in Repository,
      join: i in Issue,
      on: i.repository_id == r.id,
      where: i.state == "open" and not is_nil(r.language),
      group_by: r.language,
      select: {r.language, count(i.id)},
      order_by: [desc: count(i.id)]
    )
    |> Repo.all()
  end

  def count_open_issues do
    from(i in Issue, where: i.state == "open")
    |> Repo.aggregate(:count)
  end

  def list_repositories_with_issues(opts \\ []) do
    language = Keyword.get(opts, :language)

    from(r in Repository,
      join: i in Issue,
      on: i.repository_id == r.id,
      where: i.state == "open",
      group_by: r.id,
      select: %{
        id: r.id,
        owner: r.owner,
        name: r.name,
        full_name: r.full_name,
        description: r.description,
        language: r.language,
        stars: r.stars,
        issue_count: count(i.id)
      },
      order_by: [desc: r.stars]
    )
    |> maybe_filter_language(language)
    |> Repo.all()
  end

  defp maybe_filter_language(query, nil), do: query
  defp maybe_filter_language(query, ""), do: query
  defp maybe_filter_language(query, language), do: where(query, [r], r.language == ^language)

  # Installations

  def upsert_installation(attrs) do
    %Installation{}
    |> Installation.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, [:account_login, :account_type, :status, :updated_at]},
      conflict_target: :github_installation_id,
      returning: true
    )
  end

  def mark_installation_deleted(github_installation_id) do
    case Repo.get_by(Installation, github_installation_id: github_installation_id) do
      nil ->
        {:error, :not_found}

      installation ->
        installation
        |> Installation.changeset(%{status: "deleted"})
        |> Repo.update()
    end
  end

  def get_installation_by_github_id(github_installation_id) do
    Repo.get_by(Installation, github_installation_id: github_installation_id)
  end

  # Repositories

  def upsert_repository(attrs) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert(
      on_conflict:
        {:replace, [:owner, :name, :full_name, :description, :language, :stars, :updated_at]},
      conflict_target: :github_id,
      returning: true
    )
  end

  def get_repository_by_github_id(github_id) do
    Repo.get_by(Repository, github_id: github_id)
  end

  def get_repository_by_full_name(full_name) do
    Repo.get_by(Repository, full_name: full_name)
  end

  # Issues

  def upsert_issue(attrs) do
    %Issue{}
    |> Issue.changeset(attrs)
    |> Repo.insert(
      on_conflict:
        {:replace, [:title, :body, :labels, :state, :has_open_pr, :html_url, :updated_at]},
      conflict_target: :github_id,
      returning: true
    )
  end

  def delete_issue_by_github_id(github_id) do
    case Repo.get_by(Issue, github_id: github_id) do
      nil -> {:ok, nil}
      issue -> Repo.delete(issue)
    end
  end

  def get_issue_by_repo_and_number(repository_id, number) do
    Repo.get_by(Issue, repository_id: repository_id, number: number)
  end

  def update_issue_has_open_pr(repository_id, issue_number, has_open_pr) do
    case get_issue_by_repo_and_number(repository_id, issue_number) do
      nil ->
        {:error, :not_found}

      issue ->
        issue
        |> Issue.changeset(%{has_open_pr: has_open_pr})
        |> Repo.update()
    end
  end
end
