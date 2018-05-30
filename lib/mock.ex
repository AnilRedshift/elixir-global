defmodule Modglobal.Mock do

  def setup(_mock, _module, []), do: :ok
  def setup(mock, module, [{command, args, returns} | tail]) do
    args = [module: module] ++ args
    Mox.expect(mock, command, 1, fn (^args) ->
      setup(mock, module, tail)
      returns
    end)
    :ok
  end

  def setup(_mock, []), do: :ok
  def setup(mock, [{command, returns} | tail]) do
    Mox.expect(mock, command, 1, fn(_args) ->
      setup(mock, tail)
      returns
    end)
    :ok
  end
end
