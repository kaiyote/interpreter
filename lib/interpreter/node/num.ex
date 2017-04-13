defmodule Interpreter.Node.Num do
  @moduledoc "A node that just contains a number"

  alias Interpreter.{Token}

  @typedoc "The `Num` AST node"
  @type t :: %__MODULE__{
    token: Token.t | nil,
    value: integer
  }

  defstruct [:token, :value]

  @doc ~S"""
  Given a `Token` with type `:integer`, returns a `Num` node

  Example:

      iex> Interpreter.Node.Num.num(Interpreter.Token.token :integer, 4)
      %Interpreter.Node.Num{token: %Interpreter.Token{type: :integer, value: 4}, value: 4}
  """
  @spec num(Token.t) :: t
  def num(%{type: :integer, value: val} = token) do
    %__MODULE__{token: token, value: val}
  end
end

defimpl String.Chars, for: Interpreter.Node.Num do
  def to_string(num) do
    "%Num{#{num.value}}"
  end
end
