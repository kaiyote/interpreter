defmodule Interpreter.Node.BinOp do
  @moduledoc ~S"""
  A node with two children and an operation to perform using them

  Example:

      iex> alias Interpreter.Node.{BinOp, Num}
      iex> %BinOp{left: %Num{value: 1}, op: :plus, right: %Num{value: 1}}
      %Interpreter.Node.BinOp{left: %Interpreter.Node.Num{value: 1}, op: :plus, right: %Interpreter.Node.Num{value: 1}}
  """

  alias Interpreter.Node

  @typedoc "The `BinOp` AST node"
  @type t :: %__MODULE__{
    left: Node.t,
    op: :plus | :minus | :integer_div | :float_div | :mul,
    right: Node.t
  }

  defstruct [:left, :op, :right]
end
