defmodule KafkaUiWeb.EventLive.Index do
  use KafkaUiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: KafkaUi.MessageHandler.subscribe()

    {:ok,
     socket
     |> assign(:messages, KafkaUi.EventCache.all())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :payload, %{"payload" => payload}) do
    socket
    |> assign(:payload, payload)
  end

  @impl true
  def handle_info({:event, message}, socket) do
    {:noreply,
     update(socket, :messages, fn messages -> [message | messages] |> Enum.take(200) end)}
  end
end
