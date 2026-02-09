defmodule LlmWelcome.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LlmWelcomeWeb.Telemetry,
      LlmWelcome.Repo,
      {DNSCluster, query: Application.get_env(:llm_welcome, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LlmWelcome.PubSub},
      # Start a worker by calling: LlmWelcome.Worker.start_link(arg)
      # {LlmWelcome.Worker, arg},
      # Start to serve requests, typically the last entry
      LlmWelcomeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LlmWelcome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LlmWelcomeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
