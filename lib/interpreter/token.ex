defmodule Interpreter.Token do
  @moduledoc """
  The `Token` struct. Holds the type of token, and its value

  Example:

      iex> %Interpreter.Token{type: :integer, value: 8}
      %Interpreter.Token{type: :integer, value: 8}
  """

  @typedoc "The valid token type atoms"
  @type token_type :: :integer | :plus | :minus | :mul | :div | :lparen | :rparen | :id | :assign |
                      :begin | :end | :semi | :dot | :eof

  @typedoc "The `Token` Struct type"
  @type t :: %__MODULE__{
    type: token_type,
    value: any
  }

  defstruct [:type, :value]
end
