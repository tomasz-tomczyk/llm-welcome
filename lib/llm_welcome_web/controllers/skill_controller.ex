defmodule LlmWelcomeWeb.SkillController do
  use LlmWelcomeWeb, :controller

  @external_resource llm_welcome_path = Path.expand("../../../llm-welcome.skill.md", __DIR__)
  @llm_welcome_content File.read!(llm_welcome_path)

  @external_resource prepare_path =
                       Path.expand("../../../prepare-for-llm-welcome.skill.md", __DIR__)
  @prepare_content File.read!(prepare_path)

  def llm_welcome(conn, _params) do
    conn
    |> put_resp_content_type("text/markdown", "utf-8")
    |> resp(200, @llm_welcome_content)
    |> send_resp()
  end

  def prepare(conn, _params) do
    conn
    |> put_resp_content_type("text/markdown", "utf-8")
    |> resp(200, @prepare_content)
    |> send_resp()
  end
end
