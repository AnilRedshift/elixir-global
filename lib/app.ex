defmodule Modglobal.App do
  use Application

  @impl true
  @doc false
  def start(_type, _args) do
    Supervisor.start_link(children(Mix.env), strategy: :one_for_one)
  end

  defp children(env) when env == :test do
    case Modglobal.Server.impl() do
      Modglobal.Server.Impl -> children(:dev)
      _ -> []
    end
  end

  defp children(_env) do
    [{Modglobal.Server.Impl, name: Modglobal.Server.Impl}]
  end
end
