defmodule ExtendedTypes do
  @moduledoc """
  Extended types.

  Imports additional types to your module, by calling `use ExtendedTypes, options`.

  `options` can be:

  * `:all?`: when set to `true`, it imports all the available types.
  * `:only`: keyword list containing all the types and arity of the types to be imported.
  * `:except`: keyword list containing all the types and arity of the types to be excluded.
    This options overrides `:all?` and `:only`.

  ## Examples

      defmodule Foo do
        use ExtendedTypes, all?: true

        @spec sample :: nonempty_keyword()
        def sample(), do: [a: 1]
      end

      defmodule Bar do
        use ExtendedTypes, only: [string_map: 0, atom_map: 0]

        @spec my_map(atom) :: atom_map()
        @spec my_map(String.t) :: string_map()
        def my_map(key) when is_atom(key), do: %{a: 1}
        def my_map(key) when is_binary(key), do: %{"a" => 1}
      end
  """

  defmacro __using__(options \\ []) do
    all? =
      if options == [] do
        false
      else
        Keyword.get(options, :all?, false)
      end

    for {type, arity, quoted} <- ExtendedTypes.Types.types() do
      load? =
        case load(options, type, arity) do
          true -> true
          false -> false
          nil -> all?
        end

      if load? do
        quoted
      end
    end
  end

  defp load(options, type, arity) when is_integer(arity) do
    only = Keyword.get(options, :only, [])
    except = Keyword.get(options, :except, [])

    cond do
      except[type] == arity ->
        false

      only[type] == arity ->
        true

      true ->
        nil
    end
  end
end
