defmodule Modglobal.App do
  use Application

  @impl true
  @doc false
  def start(_type, _args) do
    Supervisor.start_link(children(), strategy: :one_for_one)
  end

  defp children() do
    [{Modglobal.Server.Impl, name: Modglobal.Server.Impl}]
  end
end
