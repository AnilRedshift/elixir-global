defmodule Modglobal do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Modglobal.Server, name: Modglobal.Server}
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def get(module, key), do: get(module, key, nil)
  def get(module, key, default) do
    GenServer.call(Modglobal.Server, {:get, module: module, key: key, default: default})
  end

  def set(module, key, value) do
    GenServer.call(Modglobal.Server, {:set, module: module, key: key, value: value})
    nil
  end

  defmacro __using__(_options) do
    quote do
      defp set_global(key, value), do: Modglobal.set(__MODULE__, key, value)
      defp get_global(key), do: Modglobal.get(__MODULE__, key)
      defp get_global(key, default), do: Modglobal.get(__MODULE__, key, default)
    end
  end
end
