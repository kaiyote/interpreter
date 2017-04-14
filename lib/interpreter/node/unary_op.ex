defmodule Interpreter.Node.UnaryOp do
  @moduledoc ~S"""
  A node representing a Unary operator.
  Has the operator, and the thing its operating on
  """

  alias Interpreter.Node

  @typedoc "The `UnaryOp` struct"
  @type t :: %__MODULE__{
    op: :plus | :minus,
    expr: Node.t
  }

  defstruct [:op, :expr]
end
