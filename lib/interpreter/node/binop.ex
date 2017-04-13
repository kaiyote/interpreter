defmodule Interpreter.Node.BinOp do
  @moduledoc false

  alias Interpreter.Token
  alias Interpreter.Node.Num

  @typedoc "The allowable types of child nodes on a BinOp"
  @type node_type :: t | Num.t

  @typedoc "The `BinOp` AST node"
  @type t :: %__MODULE__{
    left: node_type,
    op: Token.t,
    right: node_type
  }

  defstruct [:left, :op, :right]

  @doc ~S"""
  Given a left and right node, and the operator, produces a `BinOp` node

  Example:

      iex> right = Interpreter.Node.Num.num(Interpreter.Token.token :integer, 1)
      iex> left = Interpreter.Node.Num.num(Interpreter.Token.token :integer, 1)
      iex> op = Interpreter.Token.token :plus, "+"
      iex> binop = Interpreter.Node.BinOp.binop right, op, left
      iex> to_string binop
      "%BinOp{%Num{1} + %Num{1}}"
  """
  @spec binop(node_type, Token.t, node_type) :: t
  def binop(left, op, right) do
    %__MODULE__{left: left, op: op, right: right}
  end
end

defimpl String.Chars, for: Interpreter.Node.BinOp do
  def to_string(binop) do
    "%BinOp{#{Kernel.to_string binop.left} #{binop.op.value} #{Kernel.to_string binop.right}}"
  end
end
