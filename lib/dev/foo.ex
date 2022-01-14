defmodule Foo do
  # @moduledoc """
  # Sample module.
  # """
  @moduledoc false

  # use ExtendedTypes
  use ExtendedTypes, all?: true
  # use ExtendedTypes, all?: true, only: [nonempty_keyword: 1]
  # use ExtendedTypes, all?: true, except: [nonempty_keyword: 1]
  # use ExtendedTypes, only: [nonempty_keyword: 1]

  # @spec foo() :: %{<<_::1, _::_*8>> => any()}
  # def foo, do: %{"a" => :b}

  @spec improper_list() :: improper_list()
  def improper_list(), do: [3 | 2]
end
