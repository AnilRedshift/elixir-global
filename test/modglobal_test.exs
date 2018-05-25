defmodule DummyModule do
  use Modglobal
  def get(key), do: get_global(key)
  def get(key, default), do: get_global(key, default)
end

defmodule ModglobalTest do

  use ExUnit.Case, async: true
  doctest Modglobal

  setup do
    start_supervised!({Modglobal.Server, name: Modglobal.Server})
    :ok
  end

  test "get returns the passed in default" do
    assert DummyModule.get("test", "cat") == "cat"
  end
end
