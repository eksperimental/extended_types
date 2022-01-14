defmodule ExtendedTypes.Evaluator.Helpers do
  @moduledoc """
  Evaluator helpers.
  """

  defmacro any(), do: quote(do: {:any, []})
  defmacro atom(), do: quote(do: {:atom, []})
  defmacro module(), do: quote(do: {:module, []})
end
