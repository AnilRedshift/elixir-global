defmodule Modglobal do
  @moduledoc ~S"""
  Modglobal provides a simple key-value store that is unique per module.
  It is useful when you would otherwise need a GenServer to hold onto some state

  ## Setup
  For each module you need globals, add `use Modglobal`.
  ## Usage
  `YourModule.set_global(key, value)`
  `YourModule.get_global(key), etc.`

  If you would rather not use the *_global convenience functions,
  the regular API is also supported as follows:

  `Modglobal.get(__MODULE__, key)`

  `Modglobal.set(__MODULE__, key, value)`, etc...
  """

  import Modglobal.Server, only: [impl: 0]

  @doc ~S"""
  Deletes a given key from the module, and returns the value deleted.
  If the key was not present, then nil is returned.
  """
  @spec delete(module(), any()) :: any()
  def delete(module, key), do: impl().delete(module: module, key: key)

  @doc ~S"""
  See get/3, where the default value is populated to be nil
  """
  @spec get(module(), any()) :: any()
  def get(module, key), do: get(module, key, nil)

  @doc ~S"""
  For a module, retrieves the value of the passed in key.
  If the key is not present, then the default value is returned
  """
  @spec get(module(), any(), any()) :: any()
  def get(module, key, default), do: impl().get(module: module, key: key, default: default)

  @doc ~S"""
  Returns true if the key is present in the global cache, false otherwise.
  Note that this just checks the presence of the keys, even falsey values will return true
  """
  @spec has?(module(), any()) :: boolean()
  def has?(module, key), do: impl().has?(module: module, key: key)

  @doc ~S"""
  Sets the value, overwriting if necessary, to the key for the given module.
  """
  @spec set(module(), any(), any()) :: nil
  def set(module, key, value), do: impl().set(module: module, key: key, value: value)

  defmacro __using__(options) do
    if (match?([public: :true], options)) do
      quote do
        def delete_global(key), do: Modglobal.delete(__MODULE__, key)
        def get_global(key), do: Modglobal.get(__MODULE__, key)
        def get_global(key, default), do: Modglobal.get(__MODULE__, key, default)
        def has_global?(key), do: Modglobal.has?(__MODULE__, key)
        def set_global(key, value), do: Modglobal.set(__MODULE__, key, value)
      end
    else
      quote do
        defp delete_global(key), do: Modglobal.delete(__MODULE__, key)
        defp get_global(key), do: Modglobal.get(__MODULE__, key)
        defp get_global(key, default), do: Modglobal.get(__MODULE__, key, default)
        defp has_global?(key), do: Modglobal.has?(__MODULE__, key)
        defp set_global(key, value), do: Modglobal.set(__MODULE__, key, value)
      end
    end
  end
end
