defmodule LlmWelcomeWeb.PageController do
  use LlmWelcomeWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
