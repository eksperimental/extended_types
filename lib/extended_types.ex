defmodule ExtendedTypes do
  @moduledoc """
  Extended types
  """

  defmacro __using__(options \\ []) do
    all? =
      if options == [] do
        true
      else
        Keyword.get(options, :all, false)
      end

    for {type, arity, quoted} <- ExtendedTypes.Types.types() do
      if all? or use?(options, type, arity) do
        quoted
      end
    end
  end

  defp use?(options, type, arity) do
    only = Keyword.get(options, :only, [])
    except = Keyword.get(options, :except, [])

    only[type] == arity and is_integer(arity) and !except[type]
    # options[type] == arity and is_integer(arity)
  end
end
