defmodule LlmWelcome.Repo.Migrations.CreateInstallations do
  use Ecto.Migration

  def change do
    create table(:installations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :github_installation_id, :bigint, null: false
      add :account_login, :string, null: false
      add :account_type, :string, null: false
      add :status, :string, null: false, default: "active"

      timestamps()
    end

    create unique_index(:installations, [:github_installation_id])
  end
end
