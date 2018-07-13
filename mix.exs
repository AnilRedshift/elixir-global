defmodule Modglobal.MixProject do
  use Mix.Project

  @version "0.2.1"
  def project do
    [
      app: :modglobal,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/AnilRedshift/modglobal",
      docs: [source_ref: "v#{@version}", main: "readme", extras: ["README.md"]],
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      mod: {Modglobal.App, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.18.3", only: :dev},
      {:mox, "~> 0.3.2"}
    ]
  end

  defp description do
    "Simple stateful key-value store for modules"
  end

  defp package do
    [
      maintainers: ["Anil Kulkarni"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/AnilRedshift/modglobal"}
    ]
  end
end
