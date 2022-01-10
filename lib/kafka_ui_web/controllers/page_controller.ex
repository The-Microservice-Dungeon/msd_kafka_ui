defmodule KafkaUiWeb.PageController do
  use KafkaUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
