defmodule ExtendedTypes.Evaluator.Tree do
  @moduledoc """
  Evaluator module for types.
  """

  @type type_name :: ExtendedTypes.type_name()

  use ExtendedTypes, only: [nonempty_keyword: 2]

  @typedoc """
  A type hierarchical structure, known as tree.
  """
  @type tree :: %{
          {type_name, arity} => leaf
        }

  @typedoc """
  A tree leaf.
  """
  @type leaf :: %{{type_name, arity} => leaf} | [{type_name, arity}]

  @doc """
  A keyword list with all the types, included the extended ones.
  """
  @spec all_types() :: nonempty_keyword(type_name, arity)
  def all_types() do
    (basic() ++ built_in() ++ literal() ++ extended())
    |> Enum.uniq()
  end

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

  This 
  """
  # NOTE: Run ExtendedTypes.Types.types_kw() to see the list of all extended types
  @spec extended() :: nonempty_keyword(type_name, arity)
  def extended() do
    [
      all: 0,
      atom_map: 0,
      atom_map: 1,
      atom_map: 2,
      empty_binary: 0,
      empty_bitstring: 0,
      empty_list: 0,
      empty_map: 0,
      empty_tuple: 0,
      falsy: 0,
      improper_list: 0,
      improper_list: 2,
      keyword: 2,
      non_pos_integer: 0,
      nonempty_keyword: 1,
      nonempty_keyword: 2,
      string_map: 0,
      string_map: 1,
      struct: 1,
      struct: 2
    ]
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
        {:all, 0} => %{
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
          {:fun} => [
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
    }
  end
end
