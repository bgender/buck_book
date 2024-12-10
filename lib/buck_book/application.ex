defmodule BuckBook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BuckBookWeb.Telemetry,
      BuckBook.Repo,
      {DNSCluster, query: Application.get_env(:buck_book, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BuckBook.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BuckBook.Finch},
      # Start a worker by calling: BuckBook.Worker.start_link(arg)
      # {BuckBook.Worker, arg},
      # Start to serve requests, typically the last entry
      BuckBookWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BuckBook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BuckBookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
