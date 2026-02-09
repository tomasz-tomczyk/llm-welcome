defmodule LlmWelcomeWeb.Plugs.RedirectWww do
  @moduledoc """
  Redirects requests from www subdomain to the bare domain.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{host: "www." <> rest} = conn, _opts) do
    url = "#{conn.scheme}://#{rest}#{conn.request_path}#{query_string(conn)}"

    conn
    |> put_resp_header("location", url)
    |> send_resp(301, "")
    |> halt()
  end

  def call(conn, _opts), do: conn

  defp query_string(%Plug.Conn{query_string: ""}), do: ""
  defp query_string(%Plug.Conn{query_string: qs}), do: "?#{qs}"
end
