defmodule Modglobal.App do
  use Application

  @impl true
  @doc false
  def start(_type, _args) do
    children = case Mix.env do
      :test -> []
      _ -> {Modglobal.Server.Impl, name: Modglobal.Server.Impl}
    end
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
