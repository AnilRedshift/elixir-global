defmodule Modglobal.Mock do

  @moduledoc """
  A test helper used to mock Modglobal for your tests
  """

  @doc """
  Sets up the ServerMock with the calls it should expect

  Returns `:ok`

  ## Examples
      Modglobal.Mock.setup(MyModule, [
        {:set, [key: :name, value: "Ada"], nil},
        {:get, [key: :name, default: nil], "Ada"},
      ])

  This would allow the real code to call `Modglobal.set_global(:name, "Ada")`, followed by
  `Modglobal.get_global(:name)`, returning `nil` for the first call, and "Ada" for the second call

  """
  def setup(module, [{command, args, returns} | tail]) do
    args = [module: module] ++ args
    Mox.expect(Modglobal.ServerMock, command, 1, fn (^args) ->
      setup(module, tail)
      returns
    end)
    :ok
  end
  def setup(_module, []), do: :ok

  @doc """
  Same as setup/2 except it doesn't validate the arguments passed in.

  ## Examples
      Modglobal.Mock.setup([
        {:set, nil},
        {:get, "Ada"},
      ])

  This would allow the real code to call `Modglobal.set_global(:name, "Ada")`, followed by
  `Modglobal.get_global(:name)`, returning `nil` for the first call, and "Ada" for the second call.

  However, it would _also_ allow `Modglobal.Mock.set(:naame, "Ada")` because the arguments aren't checked
  """
  def setup([{command, returns} | tail]) do
    Mox.expect(Modglobal.ServerMock, command, 1, fn(_args) ->
      setup(tail)
      returns
    end)
    :ok
  end
  def setup([]), do: :ok
end
