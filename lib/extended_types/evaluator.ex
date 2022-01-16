defmodule ExtendedTypes.Evaluator do
  @moduledoc """
  Evaluator module for types.
  """

  use ExtendedTypes, only: [nonempty_keyword: 2]

  @type type_name :: ExtendedTypes.type_name()

  @spec all() :: nonempty_keyword(type_name, arity)
  def all() do
    [
      atom: 0,
      bitstring: 0,
      pid: 0,
      port: 0,
      reference: 0,
      tuple: 0,
      fun: 0,
      map: 0,
      no_return: 0,

      # numbers
      float: 0,
      integer: 0,

      # lists
      list: 0,
      # nonempty_improper_list: [any(), any_but_list: 0]
      nonempty_improper_list: 2
    ]
  end

  def exclude(keyword, key) when is_atom(key) do
    Keyword.delete(keyword, key)
  end

  def exclude(keyword, list_to_remove) when is_list(list_to_remove) do
    if Keyword.keyword?(list_to_remove) do
      Enum.reduce(list_to_remove, keyword, fn {key, arity}, acc ->
        exclude(acc, key, arity)
      end)
    else
      Keyword.drop(keyword, list_to_remove)
    end
  end

  def exclude(keyword, key, arity) when is_atom(key) and arity in 0..255 do
    Enum.reject(keyword, fn
      {^key, ^arity} ->
        true

      {^key, v} when is_list(v) and length(v) == arity ->
        true

      _ ->
        false
    end)
  end

  defmacro deftype(left, right) do
    quote bind_quoted: [left: left, right: right] do
      @type unquote(ExtendedTypes.Evaluator.type_left(left)) ::
              unquote(ExtendedTypes.Evaluator.type_right(right))
    end
  end

  defmacro deftypep(left, right) do
    quote bind_quoted: [left: left, right: right] do
      @typep unquote(ExtendedTypes.Evaluator.type_left(left)) ::
               unquote(ExtendedTypes.Evaluator.type_right(right))
    end
  end

  @doc false
  def type_left(key) when is_atom(key),
    do: type_left(key, [])

  def type_left({key, arguments}) when is_atom(key) and is_list(arguments),
    do: type_left(key, arguments)

  defp type_left(key, arguments) do
    {key, arguments}
    |> format_type()
    |> Code.string_to_quoted!()
  end

  @doc false
  def type_right(types) do
    types
    |> type_union()
    |> Code.string_to_quoted!()
  end

  defp format_type({key, arity}) when is_atom(key) and arity in 0..255 do
    "#{key}(#{coma_separate(arity)})"
  end

  defp format_type({key, arguments}) when is_atom(key) and is_list(arguments) do
    "#{key}(#{coma_separate(arguments)})"
  end

  defp format_types(types) when is_list(types) do
    for {_key, _arguments} = type <- types do
      format_type(type)
    end
  end

  @doc false
  def type_union(types) when is_list(types) do
    format_types(types)
    |> Enum.join(" | ")
  end

  @doc false
  def coma_separate(0), do: ""

  def coma_separate(arity) when arity in 1..255 do
    List.duplicate("_", arity)
    |> Enum.join(", ")
  end

  def coma_separate(types) when is_list(types) do
    format_types(types)
    |> Enum.join(", ")
  end
end
