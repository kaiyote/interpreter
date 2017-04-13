defmodule Interpreter.Node.BinOp do
  @moduledoc "A node with two children and an operation to perform using them"

  alias Interpreter.Token
  alias Interpreter.Node

  @typedoc "The `BinOp` AST node"
  @type t :: %__MODULE__{
    left: Node.t,
    op: Token.t,
    right: Node.t
  }

  defstruct [:left, :op, :right]

  @doc ~S"""
  Given a left and right node, and the operator, produces a `BinOp` node

  Example:

      iex> right = Interpreter.Node.Num.num(Interpreter.Token.token :integer, 1)
      iex> left = Interpreter.Node.Num.num(Interpreter.Token.token :integer, 1)
      iex> op = Interpreter.Token.token :plus, "+"
      iex> binop = Interpreter.Node.BinOp.bin_op right, op, left
      iex> to_string binop
      "%BinOp{%Num{1} + %Num{1}}"
  """
  @spec bin_op(Node.t, Token.t, Node.t) :: t
  def bin_op(left, op, right) do
    %__MODULE__{left: left, op: op, right: right}
  end
end

defimpl String.Chars, for: Interpreter.Node.BinOp do
  def to_string(binop) do
    "%BinOp{#{Kernel.to_string binop.left} #{binop.op.value} #{Kernel.to_string binop.right}}"
  end
end
