defmodule LlmWelcome.GitHub.Installation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "installations" do
    field :github_installation_id, :integer
    field :account_login, :string
    field :account_type, :string
    field :status, :string, default: "active"

    has_many :repositories, LlmWelcome.GitHub.Repository

    timestamps()
  end

  def changeset(installation, attrs) do
    installation
    |> cast(attrs, [:github_installation_id, :account_login, :account_type, :status])
    |> validate_required([:github_installation_id, :account_login, :account_type])
    |> validate_inclusion(:account_type, ["Organization", "User"])
    |> validate_inclusion(:status, ["active", "deleted"])
    |> unique_constraint(:github_installation_id)
  end
end
