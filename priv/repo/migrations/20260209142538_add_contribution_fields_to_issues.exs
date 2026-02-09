defmodule LlmWelcome.Repo.Migrations.AddContributionFieldsToIssues do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      add :contributor, :string
      add :merged_pr_url, :string
    end
  end
end
