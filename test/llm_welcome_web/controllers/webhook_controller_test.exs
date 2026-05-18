defmodule LlmWelcomeWeb.WebhookControllerTest do
  use LlmWelcomeWeb.ConnCase, async: false

  alias LlmWelcome.GitHub

  @webhook_secret "test-webhook-secret"

  setup do
    previous_api = Application.get_env(:llm_welcome, :github_api)
    previous_secret = Application.get_env(:llm_welcome, :github_webhook_secret)

    Application.put_env(:llm_welcome, :github_api, __MODULE__.GitHubAPI)
    Application.put_env(:llm_welcome, :github_webhook_secret, @webhook_secret)

    on_exit(fn ->
      restore_env(:github_api, previous_api)
      restore_env(:github_webhook_secret, previous_secret)
    end)
  end

  test "installation created event enriches minimal repository metadata", %{conn: conn} do
    payload = %{
      "action" => "created",
      "installation" => %{
        "id" => 12_345,
        "account" => %{"login" => "acme", "type" => "Organization"}
      },
      "repositories" => [
        %{
          "id" => 98_765,
          "name" => "agent-ready",
          "full_name" => "acme/agent-ready",
          "private" => false
        }
      ]
    }

    conn = post_signed_json(conn, "installation", payload)

    assert %{"ok" => true} = json_response(conn, 200)

    repository = GitHub.get_repository_by_github_id(98_765)

    assert repository.owner == "acme"
    assert repository.name == "agent-ready"
    assert repository.full_name == "acme/agent-ready"
    assert repository.description == "Full repository description"
    assert repository.language == "Elixir"
    assert repository.stars == 42
  end

  defmodule GitHubAPI do
    def get_repo(12_345, "acme", "agent-ready") do
      {:ok,
       %{
         "description" => "Full repository description",
         "language" => "Elixir",
         "stargazers_count" => 42
       }}
    end
  end

  defp post_signed_json(conn, event, payload) do
    body = JSON.encode!(payload)

    conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("x-github-event", event)
    |> put_req_header("x-hub-signature-256", signature(body))
    |> post(~p"/webhooks/github", body)
  end

  defp signature(body) do
    digest = :crypto.mac(:hmac, :sha256, @webhook_secret, body) |> Base.encode16(case: :lower)
    "sha256=#{digest}"
  end

  defp restore_env(key, nil), do: Application.delete_env(:llm_welcome, key)
  defp restore_env(key, value), do: Application.put_env(:llm_welcome, key, value)
end
