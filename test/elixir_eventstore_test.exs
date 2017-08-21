defmodule ElixirEventstoreTest do
  use ExUnit.Case
  doctest ElixirEventstore

  test "greets the world" do
    assert ElixirEventstore.hello() == :world
  end
end
