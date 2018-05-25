defmodule Modglobal.App do
  use Application

  @impl true
  @doc false
  def start(_type, _args) do
    children = [
      {Modglobal.Server, name: Modglobal.Server}
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
