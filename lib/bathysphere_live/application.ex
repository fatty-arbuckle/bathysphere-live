defmodule BathysphereLive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BathysphereLiveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BathysphereLive.PubSub},
      # Start the Endpoint (http/https)
      BathysphereLiveWeb.Endpoint,
      # Start a worker by calling: BathysphereLive.Worker.start_link(arg)
      # {BathysphereLive.Worker, arg}
      { BathysphereLive.Backend.Game, {} }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BathysphereLive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BathysphereLiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
