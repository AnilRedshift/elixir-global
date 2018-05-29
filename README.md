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

Typically, the easiest way to use modglobal is to use get_global with a default value.
If you use modglobal in this way, you don't need to hook up your module to your Application's children,
as no PID is needed. This way also allows you to return `{:error, error}` on application startup if the appropriate conditions aren't held

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

However, if you have state that you want to initialize right away, and don't want to stick it inside another process, you can do something like this:

#### application.ex
```elixir
children = [
  worker(Greeter, [])
]
```
#### greeter.ex

```elixir
defmodule Greeter do
  use Modglobal

  def start_link() do
    set_global(:name, "world")
    :ignore
  end

  def greet() do
    name = get_global(:name)
    IO.puts("Hello, #{name}!")
  end
end
```
