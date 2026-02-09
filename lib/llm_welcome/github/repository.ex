defmodule LlmWelcome.GitHub.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "repositories" do
    field :github_id, :integer
    field :owner, :string
    field :name, :string
    field :full_name, :string
    field :description, :string
    field :language, :string
    field :stars, :integer, default: 0

    belongs_to :installation, LlmWelcome.GitHub.Installation
    has_many :issues, LlmWelcome.GitHub.Issue

    timestamps()
  end

  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [
      :github_id,
      :installation_id,
      :owner,
      :name,
      :full_name,
      :description,
      :language,
      :stars
    ])
    |> validate_required([:github_id, :installation_id, :owner, :name, :full_name])
    |> unique_constraint(:github_id)
    |> foreign_key_constraint(:installation_id)
  end
end
