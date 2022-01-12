defmodule ExtendedTypes do
  @moduledoc """
  Extended types
  """

  @typedoc """
  A non-positive integer.

  That is, any integer `<= 0`.
  """
  @type non_pos_integer :: 0 | neg_integer()

  @typedoc """
  A keyword list with `key_type` specified.

  For example: `keyword(version :: atom(), map())`
  """
  @type keyword(key_type, value_type) :: list({key_type, value_type})

  @typedoc """
  A non-empty keyword list.
  """
  @type nonempty_keyword(value_type) :: nonempty_list({atom(), value_type})

  @typedoc """
  A non-empty keyword list with `key_type` specified.

  For example: `nonempty_keyword(version :: atom(), map())`
  """
  @type nonempty_keyword(key_type, value_type) :: nonempty_list({key_type, value_type})

  @typedoc """
  Falsey. Any valud that is `nil` or `false`.
  """
  @type falsey :: nil | false

  @typedoc """
  Map with UTF-8 string key.
  """
  @type string_map :: %{String.t() => any()}

  @typedoc """
  Map with UTF-8 string key and with value of `value_type`.
  """
  @type string_map(value_type) :: %{String.t() => value_type}

  @typedoc """
  Map with atom key.
  """
  @type atom_map :: %{atom => any()}

  @typedoc """
  Map with atom key and with value of `value_type`.
  """
  @type atom_map(value_type) :: %{atom => value_type}

  # @typedoc """
  # Non-empty bitstring.

  # Note: this type will be available in Elixir when OTP24+ is supported exclusively.
  # """
  # @type nonempty_bitstring :: <<_::1, _::_*1>>

  # @typedoc """
  # Non-empty binary.

  # Note: this type will be available in Elixir when OTP24+ is supported exclusively.
  # """
  # @type nonempty_binary :: <<_::8, _::_*8>>

  @typedoc """
  Any value except `none` (aka `no_return`).
  """
  @type some ::
          atom
          | bitstring
          | pid
          | port
          | reference
          | tuple
          | fun
          | map

          # numbers
          | float
          | integer

          # lists
          | list()
          | nonempty_improper_list(any, any)

  @type any_but_empty_list ::
          atom
          | bitstring
          | float
          | fun
          | integer
          | map
          | nonempty_maybe_improper_list(any, any)
          | pid
          | port
          | reference
          | tuple

  # Aliases

  @typedoc """
  Empty bitstring.

  Alias of `<<>>`. This is to bring typespecs mentally closer to pattern matching, while patter-matching `<<>>` matches any type of bitstring.
  """
  @type empty_bitstring :: <<>>

  @typedoc """
  Empty binary.

  Alias of `<<>>`. This is to bring typespecs mentally closer to pattern matching, while patter-matching `<<>>` matches any type of binary.
  """
  @type empty_binary :: <<>>

  @typedoc """
  Empty map.

  Alias of `%{}`. This is to bring typespecs mentally closer to pattern matching, while patter-matching `%{}` matches any type of map.
  """
  @type empty_map :: %{}

  @typedoc """
  Improper list.

  Alias of `nonempty_improper_list(any, any)`.
  """
  @type improper_list :: nonempty_improper_list(any, any)

  @typedoc """
  Improper list.

  Alias of `nonempty_maybe_improper_list(content_type, termination_type)`.
  """
  @type improper_list(content_type, termination_type) ::
          nonempty_maybe_improper_list(content_type, termination_type)
end
