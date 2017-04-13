defmodule Interpreter.Node.UnaryOp do
  @moduledoc ~S"""
  A node representing a Unary operator.
  Has the operator, and the thing its operating on

  Example:

    iex> %Interpreter.Node.UnaryOp{op: :plus, expr: %Interpreter.Node.Num{value: 3.14}}
    %Interpreter.Node.UnaryOp{op: :plus, expr: %Interpreter.Node.Num{value: 3.14}}

    iex> %Interpreter.Node.UnaryOp{op: :minus, expr: %Interpreter.Node.Num{value: 3}}
    %Interpreter.Node.UnaryOp{op: :minus, expr: %Interpreter.Node.Num{value: 3}}
  """

  alias Interpreter.Node

  @typedoc "The `UnaryOp` struct"
  @type t :: %__MODULE__{
    op: :plus | :minus,
    expr: Node.t
  }

  defstruct [:op, :expr]
end
