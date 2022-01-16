defmodule ExtendedTypes.Evaluator.Tree do
  @moduledoc """
  Evaluator module for types.
  """

  use ExtendedTypes, only: [nonempty_keyword: 2]

  @type type_name :: ExtendedTypes.type_name()

  defguardp is_tree(tree) when is_map(tree) or is_list(tree)

  defguardp is_arity(arity) when arity in 0..255

  defguardp is_type_tuple(type_tuple)
            when is_tuple(type_tuple) and tuple_size(type_tuple) == 2 and
                   is_atom(elem(type_tuple, 0)) and is_arity(elem(type_tuple, 1))

  defguardp is_level(term) when term == :infinity or (is_integer(term) and term >= 1)

  @typedoc """
  A type hierarchical structure, known as tree.
  """
  @type tree :: %{
          optional({type_name, arity}) => leaf,
          optional(type_name) => arity
        }

  @typedoc """
  A tree leaf.
  """
  @type leaf ::
          %{
            optional({type_name, arity}) => leaf,
            optional(type_name) => arity
          }
          | [{type_name, arity}]

  @doc """
  A keyword list with all the types, included the extended ones.
  """
  @spec all_types() :: nonempty_keyword(type_name, arity)
  def all_types() do
    (basic() ++ built_in() ++ literal() ++ extended())
    |> Enum.uniq()
  end

  @typedoc """
  level when walking a tree.
  """
  @type level :: pos_integer | :infinity

  @doc """
  Keyword list of basic types.

  See the list of basic types in the Elixir documentation for more information:
  <https://hexdocs.pm/elixir/typespecs.html#basic-types>
  """
  @spec basic() :: nonempty_keyword(type_name, arity)
  def basic() do
    [
      any: 0,
      none: 0,
      atom: 0,
      map: 0,
      pid: 0,
      port: 0,
      reference: 0,
      tuple: 0,
      float: 0,
      integer: 0,
      neg_integer: 0,
      non_neg_integer: 0,
      pos_integer: 0,
      list: 1,
      nonempty_list: 1,
      maybe_improper_list: 2,
      nonempty_improper_list: 2,
      nonempty_maybe_improper_list: 2
    ]
  end

  @doc """
  Keyword list of built-in types.

  See the list of built-in in the Elixir documentation for more information:
  <https://hexdocs.pm/elixir/typespecs.html#built-in-types>
  """
  @spec built_in() :: nonempty_keyword(type_name, arity)
  def built_in() do
    [
      term: 0,
      arity: 0,
      as_boolean: 1,
      binary: 0,
      bitstring: 0,
      boolean: 0,
      byte: 0,
      char: 0,
      charlist: 0,
      nonempty_charlist: 0,
      fun: 0,
      function: 0,
      identifier: 0,
      iodata: 0,
      iolist: 0,
      keyword: 0,
      keyword: 1,
      list: 0,
      nonempty_list: 0,
      maybe_improper_list: 0,
      nonempty_maybe_improper_list: 0,
      mfa: 0,
      module: 0,
      no_return: 0,
      node: 0,
      number: 0,
      struct: 0,
      timeout: 0
    ]
  end

  @doc """
  Keyword list of literal types.

  It is not possible to reprensent this set of types, so here are the ones
  that resemble those in the documentation list.

  See the list of literal types in the Elixir documentation for more information:
  <https://hexdocs.pm/elixir/typespecs.html#literals>
  """
  @spec literal() :: nonempty_keyword(type_name, arity)
  def literal() do
    [
      empty_binary: 0,
      nonempty_binary: 0,
      empty_bitstring: 0,
      nonempty_bitstring: 0,
      empty_list: 0,
      empty_map: 0,
      empty_tuple: 0
    ]
  end

  @doc """
  Keyword list of extended types.
  """
  @spec extended() :: nonempty_keyword(type_name, arity)
  def extended() do
    ExtendedTypes.Types.types_kw()
  end

  @doc """
  A map of type aliases and the type they resolve to.
  """
  @spec aliases() :: %{{type_name, arity} => {type_name, arity}}
  def aliases() do
    %{
      {:arity, 0} => {:byte, 0},
      {:atom_map, 0} => {:atom_map, 2},
      {:atom_map, 1} => {:atom_map, 2},
      {:function, 0} => {:fun, 0},
      {:improper_list, 0} => {:nonempty_improper_list, 2},
      {:improper_list, 2} => {:nonempty_improper_list, 2},
      {:keyword, 0} => {:keyword, 1},
      {:keyword, 2} => {:keyword, 1},
      {:list, 0} => {:list, 1},
      {:maybe_improper_list, 0} => {:maybe_improper_list, 2},
      {:module, 0} => {:atom, 0},
      {:no_return, 0} => {:none, 0},
      {:node, 0} => {:atom, 0},
      {:nonempty_keyword, 1} => {:nonempty_keyword, 2},
      {:nonempty_list, 0} => {:nonempty_list, 1},
      {:nonempty_maybe_improper_list, 0} => {:nonempty_maybe_improper_list, 1},
      {:string_map, 0} => {:string_map, 1},
      {:struct, 1} => {:struct, 0},
      {:struct, 2} => {:struct, 0},
      {:term, 0} => {:any, 0}
    }
  end

  @doc """
  A type tree.

  This idea of this tree is to be used for excluding certain types from others.
  So any type that belongs to a parent must be fully contained,
  so when we exclude a parent, all its descendents should be excluded as well.

  ## Structure
  The structure is a map that contains a key in the shape of `{type_name, arity}`
  where `type_name` is an atom, and the value of could be either a map with the
  same structure, or a keyword list, depending on whether the children has children
  or not.

  See the `t:tree/0` and `t:leaf/0` for a more detailed view of the structure.
  """
  @spec tree() :: tree()
  def tree() do
    %{
      {:any, 0} => %{
        {:atom, 0} => [
          boolean: 0,
          falsy: 0
        ],
        {:map, 0} => %{
          :empty_map => 0,
          :string_map => 1,
          {:atom_map, 2} => [
            struct: 0
          ]
        },
        :pid => 0,
        :port => 0,
        :reference => 0,
        {:tuple, 0} => [
          empty_tuple: 0,
          mfa: 0
        ],
        {:number, 0} => %{
          :float => 0,
          {:integer, 0} => %{
            {:non_neg_integer, 0} => %{
              :pos_integer => 0,
              {:char, 0} => [
                byte: 0
              ]
            },
            {:non_pos_integer, 0} => [
              neg_integer: 0
            ]
          }
        },
        {:maybe_improper_list, 2} => %{
          {:list, 1} => %{
            :empty_list => 0,
            {:nonempty_list, 1} => [
              nonempty_charlist: 0,
              nonempty_keyword: 2
            ],
            {:charlist, 0} => [
              nonempty_charlist: 0
            ],
            {:keyword, 1} => [
              nonempty_keyword: 2
            ]
          },
          {:nonempty_maybe_improper_list, 2} => [
            nonempty_list: 1,
            nonempty_improper_list: 2
          ],
          :nonempty_improper_list => 2,
          :iolist => 0
        },
        {:fun, 0} => [
          as_boolean: 1
        ],
        {:bitstring, 0} => %{
          {:empty_bitstring, 0} => [
            empty_binary: 0
          ],
          {:nonempty_bitstring, 0} => %{
            {:binary, 0} => [
              empty_binary: 0,
              nonempty_binary: 0
            ]
          }
        },
        :identifier => 0,
        :iodata => 0,
        :timeout => 0,
        :none => 0
      }
    }
  end

  @doc """
  Returns a keyword list of aliases for the given `type_name` and `arity`.

  The result includes the passed `type_name` and `arity`.
  """
  def find_aliases({type_name, arity} = type_tuple) when is_type_tuple(type_tuple) do
    find_aliases([{type_name, arity}], [])
  end

  def find_aliases(list) when is_list(list) do
    find_aliases(list, [])
  end

  @doc """
  Returns a keyword list of aliases for the given `type_name` and `arity`.

  The result does not include the passed `type_name` and `arity`.
  """
  def find_only_aliases({type_name, arity} = type_tuple) when is_type_tuple(type_tuple) do
    find_only_aliases([{type_name, arity}])
  end

  def find_only_aliases(list) when is_list(list) do
    find_aliases(list, []) -- list
  end

  defp find_aliases(list, aliases_acc) do
    new_aliases =
      for {type_name, arity} <- list do
        Enum.reduce(aliases(), [], fn
          {{^type_name, ^arity}, {k2, v2}}, acc ->
            [{k2, v2} | acc]

          {{k1, v1}, {^type_name, ^arity}}, acc ->
            [{k1, v1} | acc]

          {{_k1, _v1}, {_k2, _v2}}, acc ->
            acc
        end)
      end
      |> List.flatten()

    new_aliases_acc = (list ++ new_aliases ++ aliases_acc) |> clean_up_list()

    if new_aliases_acc == aliases_acc do
      new_aliases_acc
    else
      find_aliases(new_aliases, new_aliases_acc)
    end
  end

  @doc """
  Gets all the children from `tree` for the given `type_name` and `arity`.

  `level` determines how many levels downs it should go. Defaults to `:infinity`.

  The [`aliases`](`aliases/0`) are considered.
  """
  @spec get_current_and_children(tree, {type_name, arity}, level) :: [{type_name, arity}]
  def get_current_and_children(tree, {type_name, arity} = type_tuple, level \\ :infinity)
      when is_tree(tree) and is_type_tuple(type_tuple) and is_level(level) do
    aliases = find_aliases(type_tuple)

    children =
      for {type_name, arity} <- aliases do
        do_get_children(tree, {type_name, arity}, level)
      end

    ([{type_name, arity}] ++ aliases ++ children)
    |> clean_up_list()
  end

  defp do_get_children(tree, {type_name, arity}, level) when is_map(tree) or is_list(tree) do
    Enum.find_value(tree, fn
      {{^type_name, ^arity}, children} ->
        flatten(children, level)

      {{_type_name, _arity}, children} ->
        do_get_children(children, {type_name, arity}, level)

      {^type_name, ^arity} ->
        [{type_name, arity}]

      {_type_name, _children} ->
        false
    end)
  end

  defp decrease_level(level) when is_integer(level) and level >= 1, do: level - 1
  defp decrease_level(level) when is_integer(level), do: 0
  defp decrease_level(:infinity), do: :infinity

  @spec flatten(tree, level) :: keyword
  def flatten(tree, level \\ :infinity)

  def flatten(tree, level) when is_level(level) do
    flatten(tree, level, [])
  end

  defp flatten(tree, level, acc) when is_list(acc) do
    Enum.reduce(tree, acc, fn
      {{type_name, arity}, children}, acc when is_atom(type_name) and is_arity(arity) ->
        new_level = decrease_level(level)

        if new_level == 0 do
          [{type_name, arity} | acc]
        else
          flatten(children, new_level, [{type_name, arity} | acc])
        end

      {type_name, arity}, acc when is_atom(type_name) and is_arity(arity) ->
        [{type_name, arity} | acc]
    end)
  end

  @doc """
  Populates the list of types with the aliases of all its elements.
  """
  @spec populate_with_aliases([]) :: []
  @spec populate_with_aliases([type_name, ...]) :: [type_name, ...]
  def populate_with_aliases([]), do: []

  def populate_with_aliases(list) when is_list(list) do
    (find_only_aliases(list) ++ list)
    |> clean_up_list()
  end

  # def remove_aliases(list) when is_list(list) do
  #   aliases = find_only_aliases(list)

  #   (list -- aliases)
  #   |> clean_up_list()
  # end

  @doc """
  Cleans ups the list.

  Clean up the list by flattening it, removing duplicates and `nil` and sorting it.
  """
  def clean_up_list(list) when is_list(list) do
    list
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.reject(&is_nil/1)
    |> Enum.sort()
  end
end
