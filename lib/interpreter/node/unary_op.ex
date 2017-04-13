defmodule Interpreter.Node.UnaryOp do
  @moduledoc """
  A node representing a Unary operator.
  Has the operator, and the thing its operating on
  """

  alias Interpreter.{Node, Token}

  @typedoc "The `UnaryOp` struct"
  @type t :: %__MODULE__{
    op: Token.t,
    expr: Node.t
  }

  defstruct [:op, :expr]

  @doc ~S"""
  Given a `Token` (of `:type` `:plus` or `:minus`) and an expression, produces a UnaryOp node

  Example:

      iex> op = Interpreter.Token.token :plus, "+"
      iex> expr = Interpreter.Node.Num.num(Interpreter.Token.token :integer, 3)
      iex> op |> Interpreter.Node.UnaryOp.unary_op(expr) |> to_string()
      "%UnaryOp{ + (%Num{3})}"

      iex> op = Interpreter.Token.token :minus, "-"
      iex> expr = Interpreter.Node.Num.num(Interpreter.Token.token :integer, 3)
      iex> op |> Interpreter.Node.UnaryOp.unary_op(expr) |> to_string()
      "%UnaryOp{ - (%Num{3})}"
  """
  @spec unary_op(Token.t, Node.t) :: t
  def unary_op(%{type: type} = op, expr) when type in ~w(plus minus)a do
    %__MODULE__{op: op, expr: expr}
  end
end

defimpl String.Chars, for: Interpreter.Node.UnaryOp do
  def to_string(%{op: op, expr: expr}) do
    "%UnaryOp{ #{op.value} (#{Kernel.to_string expr})}"
  end
end
