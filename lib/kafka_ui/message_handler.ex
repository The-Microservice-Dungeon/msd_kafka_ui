defmodule KafkaUi.MessageHandler do
  @moduledoc false

  use Elsa.Consumer.MessageHandler

  require Logger

  def init(args) do
    {:ok, args}
  end

  def handle_messages(messages, state) do
    for message <- messages do
      headers = Enum.into(message.headers, %{})

      message = %{
        headers: headers,
        topic: message.topic,
        value: Jason.decode!(message.value)
      }

      KafkaUi.EventCache.push(message)
      Logger.info(message)
      broadcast(message)
    end

    {:ack, state}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(KafkaUi.PubSub, "events")
  end

  defp broadcast(message) do
    Phoenix.PubSub.broadcast!(KafkaUi.PubSub, "events", {:event, message})
  end
end
