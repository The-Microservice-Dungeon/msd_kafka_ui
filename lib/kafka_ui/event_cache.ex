defmodule KafkaUi.EventCache do
  use GenServer

  # Client

  def start_link(default \\ []) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def push(event) do
    GenServer.cast(__MODULE__, {:push, event})
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:push, event}, state) do
    {:noreply, [event | state] |> Enum.take(200)}
  end

  @impl true
  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end
end
