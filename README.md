# Modglobal

Modglobal provides a simple key:value store that is unique per module. You should use this when you would otherwise need to spin up a GenServer to track some simple state.

Full documentation: [https://hexdocs.pm/modglobal](https://hexdocs.pm/modglobal).

## Installation

```elixir
def deps do
  [
    {:modglobal, "~> 0.1.0"}
  ]
end
```

## Usage
```elixir
defmodule Greeter do
  use Modglobal

  def save_name(name) do
    set_global(:name, name)
  end

  def greet() do
    name = get_global(:name, "world")
    IO.puts("Hello, #{name}!")
  end
end
```
