defmodule Modglobal.Mock do

  def setup(_module, []), do: :ok
  def setup(module, [{command, args, returns} | tail]) do
    args = [module: module] ++ args
    Mox.expect(Modglobal.ServerMock, command, 1, fn (^args) ->
      setup(module, tail)
      returns
    end)
    :ok
  end

  def setup([]), do: :ok
  def setup([{command, returns} | tail]) do
    Mox.expect(Modglobal.ServerMock, command, 1, fn(_args) ->
      setup(tail)
      returns
    end)
    :ok
  end
end
