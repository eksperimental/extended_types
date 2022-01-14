# Testing module.
defmodule Bar do
  @moduledoc false

  use ExtendedTypes, all?: true

  alias ExtendedTypes.Evaluator

  import Evaluator,
    only: [
      deftype: 2,
      deftypep: 2
    ]

  any_but_atom =
    Evaluator.all()
    |> Evaluator.exclude([:atom, :no_return])
    |> Evaluator.exclude(nonempty_improper_list: 2)

  deftype(:any_but_atom, any_but_atom)
  deftypep(:any_but_atom_private, any_but_atom)

  @spec x() :: any_but_atom_private
  def x(), do: []
end
