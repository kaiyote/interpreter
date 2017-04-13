defmodule Interpreter.Token do
  @moduledoc "The `Token` struct. Holds the type of token, and its value"

  @typedoc "The valid token type atoms"
  @type token_type :: :integer | :plus | :minus | :mul | :div | :lparen | :rparen | :eof

  @typedoc "The `Token` Struct type"
  @type t :: %__MODULE__{
    type: token_type | nil,
    value: any
  }

  defstruct [:type, :value]

  @doc ~S"""
  Given a valid token type, and a value, returns a %Token{}.
  Will return an empty struct if given an invalid :type

  Examples:

      iex> Interpreter.Token.token :integer, 3
      %Interpreter.Token{type: :integer, value: 3}

      iex> Interpreter.Token.token :plus, "+"
      %Interpreter.Token{type: :plus, value: "+"}
  """
  @spec token(token_type, any) :: t
  def token(type, value) do
    %__MODULE__{type: type, value: value}
  end
end

defimpl String.Chars, for: Interpreter.Token do
  def to_string(token) do
    "%Token{#{token.type}, #{token.value}}"
  end
end
