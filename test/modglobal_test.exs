defmodule DummyModule do
  use Modglobal, public: true
end

defmodule DummyPrivateModule do
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
    start_supervised!({Modglobal.Server.Impl, name: Modglobal.Server.Impl})
    :ok
  end

  describe "get" do
    test "returns the passed in default" do
      assert DummyModule.get_global("test", "cat") == "cat"
    end

    test "returns nil if a default isn't present" do
      assert DummyModule.get_global("test") == nil
    end
  end

  describe "set" do
    test "a key to a value" do
      DummyModule.set_global("test", "cat")
      assert DummyModule.get_global("test") == "cat"
    end

    test "sets nil to a value" do
      DummyModule.set_global("test", nil)
      assert DummyModule.get_global("test", "cat") == nil
    end
  end

  describe "has?" do
    test "returns false when not present" do
      assert DummyModule.has_global?("test") == false
    end

    test "returns true when present" do
      DummyModule.set_global("test", "cat")
      assert DummyModule.has_global?("test") == true
    end
  end

  describe "delete" do
    test "no-ops if not present" do
      assert DummyModule.delete_global("test") == nil
      assert DummyModule.has_global?("test") == false
    end

    test "removes the key" do
      DummyModule.set_global("test", "cat")
      assert DummyModule.delete_global("test") == "cat"
      assert DummyModule.has_global?("test") == false
    end
  end

  describe "private api" do
    test "make sure none of the methods are public" do
      global_functions = DummyPrivateModule.__info__(:functions)
      |> Enum.unzip
      |> elem(0)
      |> Enum.map(&Atom.to_string/1)
      |> Enum.filter(&String.contains?(&1, "global"))
      assert global_functions == []
    end

    test "ensure that private methods work properly" do
      assert DummyPrivateModule.has?("test") == false
      assert DummyPrivateModule.get("test") == nil
      assert DummyPrivateModule.get("test", "cats") == "cats"
      assert DummyPrivateModule.set("test", "cats") == nil
      assert DummyPrivateModule.get("test") == "cats"
      assert DummyPrivateModule.has?("test") == true
      assert DummyPrivateModule.delete("test") == "cats"
      assert DummyPrivateModule.has?("test") == false
    end
  end

  describe "uniqueness" do
    test "make sure that changing one modules variables doesn't affect the other" do
      DummyModule.set_global("test", "dogs")
      DummyPrivateModule.set("test", "cats")
      assert DummyModule.get_global("test") == "dogs"
      assert DummyPrivateModule.get("test") == "cats"
    end
  end
end
