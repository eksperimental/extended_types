defmodule ExtendedTypes.Evaluator.Helpers do
  @moduledoc """
  Evaluator helpers.
  """

  defmacro any(), do: quote(do: {:any, 0})
  defmacro atom(), do: quote(do: {:atom, 0})
  defmacro module(), do: quote(do: {:module, 0})
end
