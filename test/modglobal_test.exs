defmodule DummyModule do
  use Modglobal
  def delete(key), do: delete_global(key)
  def get(key), do: get_global(key)
  def has?(key), do: has_global?(key)
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

  test "has key returns false when not present" do
    assert DummyModule.has?("test") == false
  end

  test "has key returns true when present" do
    DummyModule.set("test", "cat")
    assert DummyModule.has?("test") == true
  end

  test "delete no-ops if not present" do
    assert DummyModule.delete("test") == nil
    assert DummyModule.has?("test") == false
  end

  test "delete removes the key" do
    DummyModule.set("test", "cat")
    assert DummyModule.delete("test") == "cat"
    assert DummyModule.has?("test") == false

  end
end
