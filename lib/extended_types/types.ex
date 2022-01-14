defmodule ExtendedTypes.Types do
  @moduledoc """
  This module lists all the types availables in `ExtendedTypes`.
  """

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

  @types {:falsy, 0,
          quote do
            @typedoc """
            Falsy. Any valud that is `nil` or `false`.
            """
            @type falsy :: nil | false
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

  @types {:atom_map, 2,
          quote do
            @typedoc """
            Map with atom `key_type` and with value of `value_type`.

            This type is equivalent to `t:ExtendedTypes.Types.atom_map/1`
            """
            @type atom_map(key_type, value_type) :: %{key_type => value_type}
          end}

  @types {:struct, 1,
          quote do
            @typedoc """
            Struct `name` with all fields of any type.

            `name` is expected to be an atom.
            """
            @type struct(name) :: %{
                    :__struct__ => name,
                    optional(atom()) => any()
                  }
          end}

  @types {:struct, 2,
          quote do
            @typedoc """
            Struct `name` with all fields of `value_type`.

            `name` is expected to be an atom.
            """
            @type struct(name, value_type) :: %{
                    :__struct__ => name,
                    optional(atom()) => value_type
                  }
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

  @types {:all, 0,
   quote do
     @typedoc """
     All types.

     A broken-down list akin to `t:any/0` or `t:term/0`.
     This is particularly usefull when you want to manually created a type that exclude certain elements.
     """
     @type all ::
             atom
             | bitstring
             | pid
             | port
             | reference
             | tuple
             | fun
             | map
             | no_return()

             # numbers
             | float
             | integer

             # lists
             | list()
             | nonempty_improper_list(any, any_but_list)
   end}

  @types {:any_but_list, 0,
          quote do
            @type any_but_list ::
                    atom
                    | bitstring
                    | float
                    | fun
                    | integer
                    | map
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

  @types {:empty_list, 0,
          quote do
            @typedoc """
            Empty list.

            Alias of `[]`.
            """
            @type empty_list :: []
          end}

  @types {:empty_tuple, 0,
          quote do
            @typedoc """
            Empty tuple.

            Alias of `%{}`.
            """
            @type empty_tuple :: {}
          end}

  @types {:improper_list, 0,
          quote do
            @typedoc """
            Improper list.

            Alias of `nonempty_improper_list(any, any)`.
            """
            @type improper_list :: nonempty_improper_list(any, any_but_list)
          end}

  @types {:improper_list, 2,
          quote do
            @typedoc """
            Improper list.

            Alias of `nonempty_maybe_improper_list(content_type, termination_type)`.
            """
            @type improper_list(content_type, termination_type) ::
                    nonempty_improper_list(content_type, termination_type)
          end}

  # load all types
  for {_type, _arity, quoted} <- @types do
    Module.eval_quoted(__MODULE__, quoted)
  end

  def types(), do: @types
end
