# KafkaUi

This application is a helpful web application for listening to, and showing Kafka events.

The application currently caches the last 200 Events in memory.
The UI reactively renders incoming events.

## Local Development

Please make sure the `local-dev-environment` of the Microservice Dungeon is running.

You can configure the topics you want to listen to in `/config/config.exs:53`

```elixir
    topics: ["gameworld-created", "spacestation-created", "playerStatus", "bank-created"],
```

### Run locally

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Have the `local-dev-environment` including Kafka running.
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Run in Docker

To start your Phoenix server:

- Install docker
- Have the `local-dev-environment` including Kafka running.
- Run `docker compose up --build`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
