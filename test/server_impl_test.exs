defmodule Server.ImplTest do

  use ExUnit.Case
  alias Modglobal.Server.Impl
  doctest Modglobal.Server.Impl

  defmodule DummyModule do end
  defmodule OtherDummyModule do end

  describe "get" do
    test "returns the passed in default" do
      assert Impl.get(module: DummyModule, key: "test", default: "cat") == "cat"
    end
  end

  describe "set" do
    test "a key to a value" do
      Impl.set(module: DummyModule, key: "test2", value: "cat")
      assert Impl.get(module: DummyModule, key: "test2", default: nil) == "cat"
    end

    test "sets nil to a value" do
      Impl.set(module: DummyModule, key: "test3", value: nil)
      assert Impl.get(module: DummyModule, key: "test3", default: "cat") == nil
    end
  end

  describe "has?" do
    test "returns false when not present" do
      assert Impl.has?(module: DummyModule, key: "test4") == false
    end

    test "returns true when present" do
      Impl.set(module: DummyModule, key: "test5", value: "cat")
      assert Impl.has?(module: DummyModule, key: "test5") == true
    end
  end

  describe "increment" do
    test "starts with 0 when not defined" do
      assert Impl.increment(module: DummyModule, key: "test6") == 0
    end

    test "Subsequent calls return 1" do
      Impl.increment(module: DummyModule, key: "test7")
      assert Impl.increment(module: DummyModule, key: "test7") == 1
    end
  end

  describe "delete" do
    test "no-ops if not present" do
      assert Impl.delete(module: DummyModule, key: "test8") == nil
      assert Impl.has?(module: DummyModule, key: "test8") == false
    end

    test "removes the key" do
      Impl.set(module: DummyModule, key: "test9", value: "cat")
      assert Impl.delete(module: DummyModule, key: "test9") == "cat"
      assert Impl.has?(module: DummyModule, key: "test9") == false
    end
  end

  describe "uniqueness" do
    test "make sure that changing one modules variables doesn't affect the other" do
      Impl.set(module: DummyModule, key: "test10", value: "dogs")
      Impl.set(module: OtherDummyModule, key: "test10", value: "cats")
      assert Impl.get(module: DummyModule, key: "test10", default: nil) == "dogs"
      assert Impl.get(module: OtherDummyModule, key: "test10", default: nil) == "cats"
    end
  end
end
