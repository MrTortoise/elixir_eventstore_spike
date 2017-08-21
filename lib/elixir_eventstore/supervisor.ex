defmodule ElixirEventstore.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link __MODULE__, :ok
  end

  @event_store ElixirEventstore.Eventstore

  def init(:ok) do
    event_store_settings = Application.get_env :elixir_eventstore, :event_store

    children = [
      worker(Extreme, [event_store_settings, [name: @event_store]])
    ]

    supervise children, strategy: :one_for_one
  end
end
