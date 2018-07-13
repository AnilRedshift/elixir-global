use Mix.Config

if Mix.env() == :test do
  config :modglobal,
    impl: Modglobal.ServerMock
end
