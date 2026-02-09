defmodule LlmWelcome.Repo do
  use Ecto.Repo,
    otp_app: :llm_welcome,
    adapter: Ecto.Adapters.Postgres
end
