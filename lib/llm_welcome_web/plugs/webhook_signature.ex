defmodule LlmWelcomeWeb.Plugs.WebhookSignature do
  @moduledoc """
  Verifies GitHub webhook signatures using the shared webhook secret.
  Expects the raw body to be cached in conn.assigns[:raw_body].
  """

  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    secret = Application.fetch_env!(:llm_welcome, :github_webhook_secret)

    with [signature] <- get_req_header(conn, "x-hub-signature-256"),
         "sha256=" <> hex_digest <- signature,
         raw_body when is_binary(raw_body) <- conn.assigns[:raw_body],
         computed <- :crypto.mac(:hmac, :sha256, secret, raw_body) |> Base.encode16(case: :lower),
         true <- Plug.Crypto.secure_compare(computed, hex_digest) do
      conn
    else
      _ ->
        Logger.warning("Webhook signature verification failed")

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, JSON.encode!(%{error: "invalid signature"}))
        |> halt()
    end
  end
end
