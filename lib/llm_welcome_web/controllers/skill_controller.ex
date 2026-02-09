defmodule LlmWelcomeWeb.SkillController do
  use LlmWelcomeWeb, :controller

  @skill_path Application.app_dir(:llm_welcome, "priv/static/llm-welcome.skill.md")

  def show(conn, _params) do
    conn
    |> put_resp_content_type("text/markdown", "utf-8")
    |> send_file(200, @skill_path)
  end
end
