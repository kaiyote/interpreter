defmodule Interpreter.Node.Num do
  @moduledoc "A node that just contains a number"

  alias Interpreter.{Token}

  @typedoc "The `Num` AST node"
  @type t :: %__MODULE__{
    value: number
  }

  defstruct [:value]

  @doc ~S"""
  Given a `Token` with type `:integer`, returns a `Num` node

  Example:

      iex> Interpreter.Node.Num.num(Interpreter.Token.token :integer, 4)
      %Interpreter.Node.Num{value: 4}

      iex> Interpreter.Node.Num.num(4)
      %Interpreter.Node.Num{value: 4}
  """
  @spec num(Token.t | number) :: t
  def num(%{type: :integer, value: val}) do
    %__MODULE__{value: val}
  end
  def num(num) when is_number(num) do
    %__MODULE__{value: num}
  end
end

defimpl String.Chars, for: Interpreter.Node.Num do
  def to_string(num) do
    "%Num{#{num.value}}"
  end
end
