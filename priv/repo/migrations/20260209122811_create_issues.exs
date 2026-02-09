defmodule LlmWelcome.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :github_id, :bigint, null: false

      add :repository_id, references(:repositories, type: :binary_id, on_delete: :delete_all),
        null: false

      add :number, :integer, null: false
      add :title, :string, null: false
      add :body, :text
      add :labels, :jsonb, default: "[]"
      add :state, :string, null: false, default: "open"
      add :has_open_pr, :boolean, null: false, default: false
      add :html_url, :string, null: false

      timestamps()
    end

    create unique_index(:issues, [:github_id])
    create index(:issues, [:repository_id])
    create index(:issues, [:state])
  end
end
