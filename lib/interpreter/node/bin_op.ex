defmodule Interpreter.Node.BinOp do
  @moduledoc "A node with two children and an operation to perform using them"

  alias Interpreter.Node

  @typedoc "The `BinOp` AST node"
  @type t :: %__MODULE__{
    left: Node.t,
    op: :plus | :minus | :integer_div | :float_div | :mul,
    right: Node.t
  }

  defstruct [:left, :op, :right]
end
