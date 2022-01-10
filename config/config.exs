# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :kafka_ui,
  ecto_repos: [KafkaUi.Repo]

# Configures the endpoint
config :kafka_ui, KafkaUiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: KafkaUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: KafkaUi.PubSub,
  live_view: [signing_salt: "fuNQFKME"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :kafka_ui, KafkaUi.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

[host, port] =
  System.get_env("KAFKA_BOOTSTRAP_ADDRESS", "localhost:29092")
  |> String.split(":")

config :kafka_ui, :elsa,
  endpoints: [{String.to_atom(host), String.to_integer(port)}],
  name: :kafka_ui,
  group_consumer: [
    group: "game-events-ui",
    topics: ["gameworld-created", "spacestation-created", "playerStatus", "bank-created"],
    handler: KafkaUi.MessageHandler,
    handler_init_args: %{},
    config: [
      begin_offset: :earliest,
      offset_reset_policy: :reset_to_earliest,
      prefetch_count: 0,
      prefetch_bytes: 2_097_152
    ]
  ]

config :tailwind,
  version: "3.0.12",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"