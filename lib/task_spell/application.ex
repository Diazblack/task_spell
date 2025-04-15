defmodule TaskSpell.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TaskSpellWeb.Telemetry,
      TaskSpell.Repo,
      {DNSCluster, query: Application.get_env(:task_spell, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TaskSpell.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TaskSpell.Finch},
      # Start a worker by calling: TaskSpell.Worker.start_link(arg)
      # {TaskSpell.Worker, arg},
      # Start to serve requests, typically the last entry
      TaskSpellWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaskSpell.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TaskSpellWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
