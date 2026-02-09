defmodule LlmWelcome.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :github_id, :bigint, null: false

      add :installation_id, references(:installations, type: :binary_id, on_delete: :delete_all),
        null: false

      add :owner, :string, null: false
      add :name, :string, null: false
      add :full_name, :string, null: false
      add :description, :text
      add :language, :string
      add :stars, :integer, default: 0

      timestamps()
    end

    create unique_index(:repositories, [:github_id])
    create index(:repositories, [:installation_id])
  end
end
