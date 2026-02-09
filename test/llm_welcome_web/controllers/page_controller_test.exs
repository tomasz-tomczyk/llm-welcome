defmodule LlmWelcomeWeb.HomeLiveTest do
  use LlmWelcomeWeb.ConnCase

  test "GET / renders homepage", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "LLM Welcome"
  end
end
