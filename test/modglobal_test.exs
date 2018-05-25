defmodule DummyModule do
  use Modglobal
  def get(key), do: get_global(key)
  def get(key, default), do: get_global(key, default)
  def set(key, value), do: set_global(key, value)
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

  test "get returns nil if a default isn't present" do
    assert DummyModule.get("test") == nil
  end

  test "set and retreive the value" do
    DummyModule.set("test", "cat")
    assert DummyModule.get("test") == "cat"
  end

  test "set and retrieve nil as a value" do
    DummyModule.set("test", nil)
    assert DummyModule.get("test", "cat") == nil
  end
end
