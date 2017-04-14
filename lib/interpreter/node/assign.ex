defmodule Interpreter.Node.Assign do
  @moduledoc "An AST node representing an assignment statement"

  alias Interpreter.Node
  alias Interpreter.Node.Var

  @typedoc "The `Assign` struct"
  @type t :: %__MODULE__{
    ident: Var.t,
    value: Node.t
  }

  defstruct [:ident, :value]
end
