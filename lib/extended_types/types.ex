defmodule ExtendedTypes.Types do
  @moduledoc false

  Module.register_attribute(__MODULE__, :types, accumulate: true)

  @types {:non_pos_integer, 0,
          quote do
            @typedoc """
            A non-positive integer.

            That is, any integer `<= 0`.
            """
            @type non_pos_integer :: 0 | neg_integer()
          end}

  @types {:keyword, 2,
          quote do
            @typedoc """
            A keyword list with `key_type` specified.

            For example: `keyword(version :: atom(), map())`
            """
            @type keyword(key_type, value_type) :: list({key_type, value_type})
          end}

  @types {:nonempty_keyword, 1,
          quote do
            @typedoc """
            A non-empty keyword list.
            """
            @type nonempty_keyword(value_type) :: nonempty_list({atom(), value_type})
          end}

  @types {:nonempty_keyword, 2,
          quote do
            @typedoc """
            A non-empty keyword list with `key_type` specified.

            For example: `nonempty_keyword(version :: atom(), map())`
            """
            @type nonempty_keyword(key_type, value_type) :: nonempty_list({key_type, value_type})
          end}

  @types {:falsey, 0,
          quote do
            @typedoc """
            Falsey. Any valud that is `nil` or `false`.
            """
            @type falsey :: nil | false
          end}

  @types {:string_map, 0,
          quote do
            @typedoc """
            Map with UTF-8 string key.
            """
            @type string_map :: %{String.t() => any()}
          end}

  @types {:string_map, 1,
          quote do
            @typedoc """
            Map with UTF-8 string key and with value of `value_type`.
            """
            @type string_map(value_type) :: %{String.t() => value_type}
          end}

  @types {:atom_map, 0,
          quote do
            @typedoc """
            Map with atom key.
            """
            @type atom_map :: %{atom => any()}
          end}

  @types {:atom_map, 1,
          quote do
            @typedoc """
            Map with atom key and with value of `value_type`.
            """
            @type atom_map(value_type) :: %{atom => value_type}
          end}

  # @types {:nonempty_bitstring, 0,
  #         quote do
  #           @typedoc """
  #           Non-empty bitstring.

  #           Note: this type will be available in Elixir when OTP24+ is supported exclusively.
  #           """
  #           @type nonempty_bitstring :: <<_::1, _::_*1>>
  #         end}

  # @types {:nonempty_binary, 0,
  #         quote do
  #           @typedoc """
  #           Non-empty binary.

  #           Note: this type will be available in Elixir when OTP24+ is supported exclusively.
  #           """
  #           @type nonempty_binary :: <<_::8, _::_*8>>
  #         end}

  @types {:some, 0,
   quote do
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
   end}

  @types {:any_but_empty_list, 0,
          quote do
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
          end}

  # Aliases
  @types {:empty_bitstring, 0,
          quote do
            @typedoc """
            Empty bitstring.

            Alias of `<<>>`. This is to bring typespecs mentally closer to pattern matching, while patter-matching `<<>>` matches any type of bitstring.
            """
            @type empty_bitstring :: <<>>
          end}

  @types {:empty_binary, 0,
          quote do
            @typedoc """
            Empty binary.

            Alias of `<<>>`. This is to bring typespecs mentally closer to pattern matching, while patter-matching `<<>>` matches any type of binary.
            """
            @type empty_binary :: <<>>
          end}

  @types {:empty_map, 0,
          quote do
            @typedoc """
            Empty map.

            Alias of `%{}`. This is to bring typespecs mentally closer to pattern matching, while patter-matching `%{}` matches any type of map.
            """
            @type empty_map :: %{}
          end}

  @types {:improper_list, 0,
          quote do
            @typedoc """
            Improper list.

            Alias of `nonempty_improper_list(any, any)`.
            """
            @type improper_list :: nonempty_improper_list(any, any)
          end}

  @types {:improper_list, 2,
          quote do
            @typedoc """
            Improper list.

            Alias of `nonempty_maybe_improper_list(content_type, termination_type)`.
            """
            @type improper_list(content_type, termination_type) ::
                    nonempty_maybe_improper_list(content_type, termination_type)
          end}

  def types(), do: @types
end
