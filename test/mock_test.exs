defmodule Server.MockTest do
  alias Modglobal.Mock
  use ExUnit.Case
  doctest Modglobal.Mock

  defmodule DummyModule do end

  describe "returns :ok" do
    test "module and an empty command list" do
      assert Mock.setup(DummyModule, []) == :ok
    end

    test "module and a command list" do
      assert Mock.setup(DummyModule, [{:get, [], nil}]) == :ok
    end

    test "empty command list" do
      assert Mock.setup([]) == :ok
    end

    test "list of commands" do
      assert Mock.setup([{:get, nil}]) == :ok
    end
  end

  describe "throws an exception" do
    setup do
      Mock.setup(DummyModule, [
        {:get, [key: :name, default: nil], nil},
        {:set, [key: :name, value: "Ada"], nil},
      ])
    end

    test "if the wrong arguments are given" do
      assert_raise(FunctionClauseError, fn -> Modglobal.ServerMock.get(module: DummyModule, key: "wrong key", default: nil) end)
    end

    test "if the wrong module is used" do
      assert_raise(FunctionClauseError, fn -> Modglobal.ServerMock.get(module: WrongModule, key: :name, default: nil) end)
    end

    test "if the function is called in the wrong order" do
      assert_raise(Mox.UnexpectedCallError, fn -> Modglobal.ServerMock.set(module: DummyModule, key: :name, value: "Ada") end)
    end
  end

  test "mocks multiple calls" do
    Mock.setup(DummyModule, [
      {:get, [key: :name, default: nil], nil},
      {:set, [key: :name, value: "Ada"], nil},
    ])
    assert Modglobal.ServerMock.get(module: DummyModule, key: :name, default: nil) == nil
    assert Modglobal.ServerMock.set(module: DummyModule, key: :name, value: "Ada") == nil
  end

  test "Also provides a simple to use API" do
    Mock.setup([
      {:get, 42},
      {:get, 19},
      {:set, nil}
    ])

    assert Modglobal.ServerMock.get(module: DummyModule, key: "foo", default: nil) == 42
    assert Modglobal.ServerMock.get(module: DummyModule, key: "bar", default: nil) == 19
    assert Modglobal.ServerMock.set(module: DummyModule, key: "baz", value: nil) == nil
  end
end
