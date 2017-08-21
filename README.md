# ElixirEventstore

**Tech spike to play with extreme - an eventstore adapter for elixir**

## Installation

`mix deps.get`
`iex -S mix`

```elixir
iex(1)> {:ok, server} = Application.get_env(:extreme, :event_store) |> Extreme.start_link

21:58:52.151 [info]  Connecting Extreme to localhost:1113
{:ok, #PID<0.208.0>}
iex(2)>
21:58:52.152 [info]  Successfully connected to EventStore @ localhost:1113
iex(2)> {:ok, response} = Extreme.execute server, ElixirEventstore.Write.write_events    
{:ok,
 %Extreme.Msg.WriteEventsCompleted{commit_position: 2425127,
  first_event_number: 0, last_event_number: 1, message: nil,
  prepare_position: 2425127, result: :Success}}
iex(3)>

```
