defmodule LlmWelcome.GitHub.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "issues" do
    field :github_id, :integer
    field :number, :integer
    field :title, :string
    field :body, :string
    field :labels, {:array, :map}, default: []
    field :state, :string, default: "open"
    field :has_open_pr, :boolean, default: false
    field :html_url, :string

    belongs_to :repository, LlmWelcome.GitHub.Repository

    timestamps()
  end

  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [
      :github_id,
      :repository_id,
      :number,
      :title,
      :body,
      :labels,
      :state,
      :has_open_pr,
      :html_url
    ])
    |> validate_required([:github_id, :repository_id, :number, :title, :html_url])
    |> unique_constraint(:github_id)
    |> foreign_key_constraint(:repository_id)
  end
end
