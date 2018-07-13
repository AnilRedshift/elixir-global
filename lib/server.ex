defmodule Modglobal.Server do

  @type key :: any()
  @type value :: any()

  @callback delete([module: module(), key: key()]) :: value() | nil
  @callback get([module: module(), key: key(), default: value()]) :: value()
  @callback has?([module: module(), key: key()]) :: boolean()
  @callback set([module: module(), key: key(), value: value()]) :: nil

  def impl() do
    Application.get_env(:modglobal, :impl, Modglobal.Server.Impl)
  end
end
