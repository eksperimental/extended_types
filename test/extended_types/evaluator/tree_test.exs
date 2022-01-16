defmodule ExtendedTypes.Evaluator.TreeTest do
  use ExUnit.Case
  alias ExtendedTypes.Evaluator.Tree

  doctest Tree

  test "aliases should not have common elements, otherwise we will fall into an infinite loop" do
    aliases = Tree.aliases()
    keys = Enum.map(aliases, fn {k, _v} -> k end)
    values = Enum.map(aliases, fn {_k, v} -> v end)

    intersection =
      MapSet.intersection(Enum.into(keys, MapSet.new()), Enum.into(values, MapSet.new()))

    assert MapSet.size(intersection) == 0
  end

  test "get_current_and_children" do
    assert Tree.get_current_and_children(Tree.tree(), {:all, 0}) |> Keyword.keyword?() == true
    assert Tree.get_current_and_children(Tree.tree(), {:all, 0}, 1) |> Keyword.keyword?() == true

    assert Tree.get_current_and_children(Tree.tree(), {:list, 0}) == [
             {:charlist, 0},
             {:empty_list, 0},
             {:keyword, 1},
             {:list, 0},
             {:list, 1},
             {:nonempty_charlist, 0},
             {:nonempty_keyword, 2},
             {:nonempty_list, 1}
           ]

    assert Tree.get_current_and_children(Tree.tree(), {:number, 0}) == [
             byte: 0,
             char: 0,
             float: 0,
             integer: 0,
             neg_integer: 0,
             non_neg_integer: 0,
             non_pos_integer: 0,
             number: 0,
             pos_integer: 0
           ]

    assert Tree.get_current_and_children(Tree.tree(), {:number, 0})
           |> Tree.populate_with_aliases() == [
             arity: 0,
             byte: 0,
             char: 0,
             float: 0,
             integer: 0,
             neg_integer: 0,
             non_neg_integer: 0,
             non_pos_integer: 0,
             number: 0,
             pos_integer: 0
           ]
  end

  test "find_aliases" do
    assert Tree.find_aliases({:list, 0}) == [{:list, 0}, {:list, 1}]
    assert Tree.find_aliases({:struct, 1}) == [{:struct, 0}, {:struct, 1}, {:struct, 2}]

    # no aliases should return the original types
    assert Tree.find_aliases({:foo, 0}) == [{:foo, 0}]
    assert Tree.find_aliases(foo: 0, bar: 1) == [bar: 1, foo: 0]
  end

  test "get_only_aliases" do
    assert Tree.find_only_aliases({:list, 0}) == [{:list, 1}]
    assert Tree.find_only_aliases({:struct, 1}) == [{:struct, 0}, {:struct, 2}]
    assert Tree.find_only_aliases(list: 0, struct: 1) == [list: 1, struct: 0, struct: 2]

    # no aliases should return empty list
    assert Tree.find_only_aliases({:foo, 0}) == []
    assert Tree.find_only_aliases(foo: 0, bar: 1) == []
  end

  test "populate_with_aliases" do
    assert Tree.populate_with_aliases([]) == []
    assert Tree.populate_with_aliases(list: 0) == [list: 0, list: 1]

    assert Tree.populate_with_aliases(list: 0, struct: 2) == [
             list: 0,
             list: 1,
             struct: 0,
             struct: 1,
             struct: 2
           ]
  end
end
