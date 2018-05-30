defmodule Server.ImplTest do

  use ExUnit.Case
  alias Modglobal.Server.Impl
  doctest Modglobal.Server.Impl

  defmodule DummyModule do end
  defmodule OtherDummyModule do end

  setup_all do
    old_env = Application.get_env(:modglobal, :impl)
    Application.put_env(:modglobal, :impl, Modglobal.Server.Impl)
    on_exit fn ->
      Application.put_env(:modglobal, :impl, old_env)
    end
  end

  setup do
    start_supervised!({Modglobal.Server.Impl, name: Modglobal.Server.Impl})
    :ok
  end

  describe "get" do
    test "returns the passed in default" do
      assert Impl.get(module: DummyModule, key: "test", default: "cat") == "cat"
    end
  end

  describe "set" do
    test "a key to a value" do
      Impl.set(module: DummyModule, key: "test", value: "cat")
      assert Impl.get(module: DummyModule, key: "test", default: nil) == "cat"
    end

    test "sets nil to a value" do
      Impl.set(module: DummyModule, key: "test", value: nil)
      assert Impl.get(module: DummyModule, key: "test", default: "cat") == nil
    end
  end

  describe "has?" do
    test "returns false when not present" do
      assert Impl.has?(module: DummyModule, key: "test") == false
    end

    test "returns true when present" do
      Impl.set(module: DummyModule, key: "test", value: "cat")
      assert Impl.has?(module: DummyModule, key: "test") == true
    end
  end

  describe "delete" do
    test "no-ops if not present" do
      assert Impl.delete(module: DummyModule, key: "test") == nil
      assert Impl.has?(module: DummyModule, key: "test") == false
    end

    test "removes the key" do
      Impl.set(module: DummyModule, key: "test", value: "cat")
      assert Impl.delete(module: DummyModule, key: "test") == "cat"
      assert Impl.has?(module: DummyModule, key: "test") == false
    end
  end

  describe "uniqueness" do
    test "make sure that changing one modules variables doesn't affect the other" do
      Impl.set(module: DummyModule, key: "test", value: "dogs")
      Impl.set(module: OtherDummyModule, key: "test", value: "cats")
      assert Impl.get(module: DummyModule, key: "test", default: nil) == "dogs"
      assert Impl.get(module: OtherDummyModule, key: "test", default: nil) == "cats"
    end
  end
end
