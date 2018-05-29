use Mix.Config

config :modglobal,
  impl: Modglobal.Server.Impl

if Mix.env() == :test do
  import_config "test.exs"
end
