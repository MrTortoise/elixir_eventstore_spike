defmodule ElixirEventstore.StreamSubscriber do
  require Logger
use GenServer

def start_link(extreme, last_processed_event), do: GenServer.start_link __MODULE__, {extreme, last_processed_event}

def init({extreme, last_processed_event}) do
  stream = "people"
  state = %{ event_store: extreme, stream: stream, last_event: last_processed_event }
  GenServer.cast self, :subscribe
  {:ok, state}
end

def handle_cast(:subscribe, state) do
  # read only unprocessed events and stay subscribed
  {:ok, subscription} = Extreme.read_and_stay_subscribed state.event_store, self, state.stream, state.last_event + 1
  # we want to monitor when subscription is crashed so we can resubscribe
  ref = Process.monitor subscription
  {:noreply, Map.put(state, :subscription_ref, ref)}
end

def handle_info({:DOWN, ref, :process, _pid, _reason}, %{subscription_ref: ref} = state) do
  GenServer.cast self, :subscribe
  {:noreply, state}
end
def handle_info({:on_event, push}, state) do
  push.event.data
  |> Poison.decode!
  |> process_event
  IO.puts(inspect push)
  event_number = push.event.event_number
  :ok = update_last_event state.stream, event_number
  {:noreply, %{state|last_event: event_number}}
end
def handle_info(:caught_up, state) do
  Logger.debug "We are up to date!"
  {:noreply, state}
end
def handle_info(_msg, state), do: {:noreply, state}

defp process_event(event), do: IO.puts("Do something with #{inspect event}")
defp update_last_event(_stream, _event_number), do: IO.puts("Persist last processed event_number for stream")
end