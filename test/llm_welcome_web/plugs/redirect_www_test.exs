defmodule LlmWelcomeWeb.Plugs.RedirectWwwTest do
  use ExUnit.Case, async: true
  import Plug.Test
  import Plug.Conn

  alias LlmWelcomeWeb.Plugs.RedirectWww

  test "redirects www to bare domain with 301" do
    conn =
      conn(:get, "/")
      |> Map.put(:host, "www.llmwelcome.dev")
      |> RedirectWww.call([])

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["http://llmwelcome.dev/"]
    assert conn.halted
  end

  test "preserves path" do
    conn =
      conn(:get, "/api/issues")
      |> Map.put(:host, "www.llmwelcome.dev")
      |> RedirectWww.call([])

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["http://llmwelcome.dev/api/issues"]
  end

  test "preserves query string" do
    conn =
      conn(:get, "/api/issues?language=Elixir")
      |> Map.put(:host, "www.llmwelcome.dev")
      |> RedirectWww.call([])

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "http://llmwelcome.dev/api/issues?language=Elixir"
           ]
  end

  test "passes through non-www requests" do
    conn =
      conn(:get, "/")
      |> Map.put(:host, "llmwelcome.dev")
      |> RedirectWww.call([])

    refute conn.halted
    refute conn.status
  end
end
