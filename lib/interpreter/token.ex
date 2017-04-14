defmodule Interpreter.Token do
  @moduledoc """
  The `Token` struct. Holds the type of token, and its value

  Example:

      iex> %Interpreter.Token{type: :integer, value: 8}
      %Interpreter.Token{type: :integer, value: 8}
  """

  @typedoc "The valid token type atoms"
  @type token_type :: :assign | :begin | :colon | :comma | :dot | :end | :eof | :float_div | :id |
                      :integer | :integer_const | :integer_div | :lparen | :minus | :mul | :plus |
                      :program | :real | :real_const | :rparen | :semi | :var

  @typedoc "The `Token` Struct type"
  @type t :: %__MODULE__{
    type: token_type,
    value: any
  }

  defstruct [:type, :value]
end
