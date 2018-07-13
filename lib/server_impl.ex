defmodule Modglobal.Server.Impl do
  use GenServer
  @behaviour Modglobal.Server

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:delete, module: module, key: key}, _from, state) do
    {value, state} = pop_in(state, [Access.key(module, %{}), key])
    {:reply, value, state}
  end

  @impl true
  def handle_call({:get, module: module, key: key, default: default}, _from, state) do
    value = state
    |> Map.get(module, %{})
    |> Map.get(key, default)
    {:reply, value, state}
  end

  @impl true
  def handle_call({:has?, module: module, key: key}, _from, state) do
    exists? = state
    |> Map.get(module, %{})
    |> Map.has_key?(key)
    {:reply, exists?, state}
  end

  @impl true
  def handle_call({:increment, module: module, key: key}, from, state) do
    {:reply, value, _state} = handle_call({:get, module: module, key: key, default: 0}, from, state)
    state = put_in(state, [Access.key(module, %{}), key], value + 1)
    {:reply, value, state}
  end

  @impl true
  def handle_call({:set, module: module, key: key, value: value}, _from, state) do
    state = put_in(state, [Access.key(module, %{}), key], value)
    {:reply, nil, state}
  end

  @impl true
  def delete([module: _, key: _] = args), do: call(:delete, args)

  @impl true
  def get([module: _, key: _, default: _] = args), do: call(:get, args)

  @impl true
  def has?([module: _, key: _] = args), do: call(:has?, args)

  @impl true
  def increment([module: _, key: _] = args), do: call(:increment, args)

  @impl true
  def set([module: _, key: _, value: _] = args), do: call(:set, args)

  defp call(command, args) do
    apply(GenServer, :call, [__MODULE__, {command, args}])
  end
end
