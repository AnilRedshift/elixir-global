defmodule ModglobalTest do
  alias Modglobal.Mock
  use ExUnit.Case
  doctest Modglobal

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


  describe "get" do
    test "returns the passed in default" do
      Mock.setup(DummyModule, [
        {:get, [key: "test", default: "cat"], "cat"}
      ])
      assert DummyModule.get_global("test", "cat") == "cat"
    end

    test "returns nil if a default isn't present" do
      Mock.setup(DummyModule, [
        {:get, [key: "test", default: nil], nil}
      ])
      assert DummyModule.get_global("test") == nil
    end
  end

  describe "set" do
    test "a key to a value" do
      Mock.setup(DummyModule, [
        {:set, [key: "test", value: "cat"], nil},
      ])
      assert DummyModule.set_global("test", "cat") == nil
    end
  end

  describe "has?" do
    test "returns true when present" do
      Mock.setup(DummyModule, [
        {:has?, [key: "test"], true},
      ])
      assert DummyModule.has_global?("test") == true
    end
  end

  describe "delete" do
    test "no-ops if not present" do
      Mock.setup(DummyModule, [
        {:delete, [key: "test"], nil},
      ])
      assert DummyModule.delete_global("test") == nil
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
      Mock.setup([
        {:has?, false},
        {:get, nil},
        {:set, nil},
        {:delete, "cats"}
      ])
      assert DummyPrivateModule.has?("test") == false
      assert DummyPrivateModule.get("test") == nil
      assert DummyPrivateModule.set("test", "cats") == nil
      assert DummyPrivateModule.delete("test") == "cats"
    end
  end
end
