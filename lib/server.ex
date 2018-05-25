defmodule Modglobal.Server do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:get, module: module, key: key, default: default}, _from, state) do
    value = state
    |> Map.get(module, %{})
    |> Map.get(key, default)
    {:reply, value, state}
  end

  @impl true
  def handle_call({:set, module: module, key: key, value: value}, _from, state) do
    state = put_in(state, [Access.key(module, %{}), key], value)
    {:reply, :ok, state}
  end
end
