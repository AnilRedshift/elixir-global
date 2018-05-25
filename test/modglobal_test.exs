defmodule ModglobalTest do
  use ExUnit.Case
  doctest Modglobal

  test "greets the world" do
    assert Modglobal.hello() == :world
  end
end
