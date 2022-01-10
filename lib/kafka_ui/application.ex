defmodule KafkaUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      KafkaUi.Repo,
      # Start the Telemetry supervisor
      KafkaUiWeb.Telemetry,
      # Start the PubSub system
      KafkaUi.EventCache,
      kafka_config(),
      {Phoenix.PubSub, name: KafkaUi.PubSub},
      # Start the Endpoint (http/https)
      KafkaUiWeb.Endpoint
      # Start a worker by calling: KafkaUi.Worker.start_link(arg)
      # {KafkaUi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KafkaUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def kafka_config() do
    {
      Elsa.Supervisor,
      endpoints: Application.get_env(:kafka_ui, :elsa)[:endpoints],
      connection: :kafka_ui_reader,
      group_consumer: Application.get_env(:kafka_ui, :elsa)[:group_consumer]
    }
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KafkaUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
