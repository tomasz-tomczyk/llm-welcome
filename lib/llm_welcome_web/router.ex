defmodule LlmWelcomeWeb.Router do
  use LlmWelcomeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LlmWelcomeWeb.Layouts, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "content-security-policy" =>
        "default-src 'self'; " <>
          "script-src 'self' 'unsafe-inline' 'unsafe-eval'; " <>
          "style-src 'self' 'unsafe-inline'; " <>
          "img-src 'self' data: https:; " <>
          "font-src 'self' data:; " <>
          "connect-src 'self' wss: ws:; " <>
          "frame-ancestors 'none'"
    }
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :webhook do
    plug :accepts, ["json"]
    plug LlmWelcomeWeb.Plugs.WebhookSignature
  end

  scope "/", LlmWelcomeWeb do
    pipe_through :browser

    live_session :public do
      live "/", HomeLive
      live "/about", AboutLive
    end

    get "/llm-welcome.skill.md", SkillController, :llm_welcome
    get "/prepare-for-llm-welcome.skill.md", SkillController, :prepare
    get "/sitemap.xml", SitemapController, :index
  end

  scope "/api", LlmWelcomeWeb do
    pipe_through :api

    get "/issues", IssueController, :index
  end

  scope "/webhooks", LlmWelcomeWeb do
    pipe_through :webhook

    post "/github", WebhookController, :github
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:llm_welcome, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LlmWelcomeWeb.Telemetry
    end
  end
end
