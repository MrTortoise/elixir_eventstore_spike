defmodule ElixirEventstore.PersonCreated do
  defstruct name: "undefined", id: UUID.uuid1()
end

defmodule ElixirEventstore.PersonChangedName do
  defstruct name: "undefined", id: UUID.uuid1()
end

defmodule ElixirEventstore.Stuff do
  alias Extreme.Msg, as: ExMsg
  alias ElixirEventstore.PersonCreated, as: PersonCreated
  alias ElixirEventstore.PersonChangedName, as: PersonChangedName

  def write_events(stream \\ "people", events \\ [%PersonCreated{name: "Pera Peric"}, %PersonChangedName{name: "Zika"}]) do
    proto_events = Enum.map(events, fn event ->
      ExMsg.NewEvent.new(
        event_id: Extreme.Tools.gen_uuid(),
        event_type: to_string(event.__struct__),
        data_content_type: 0,
        metadata_content_type: 0,
        data: Poison.encode!(event),
        metadata: ""
      ) end)
    ExMsg.WriteEvents.new(
      event_stream_id: stream,
      expected_version: -2,
      events: proto_events,
      require_master: false
    )
  end
end
