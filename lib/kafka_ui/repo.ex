defmodule KafkaUi.Repo do
  use Ecto.Repo,
    otp_app: :kafka_ui,
    adapter: Ecto.Adapters.SQLite3
end
