defmodule LlmWelcomeWeb.SkillController do
  use LlmWelcomeWeb, :controller

  @external_resource skill_path = Path.expand("../../../llm-welcome.skill.md", __DIR__)
  @skill_content File.read!(skill_path)

  def show(conn, _params) do
    conn
    |> put_resp_content_type("text/markdown", "utf-8")
    |> resp(200, @skill_content)
    |> send_resp()
  end
end
