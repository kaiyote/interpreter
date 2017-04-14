defmodule Interpreter.Node.VarDecl do
  @moduledoc "A variable declaration node"

  alias Interpreter.Node.{Type, Var}

  @typedoc "The `VarDecl` struct"
  @type t :: %__MODULE__{
    var: Var.t,
    type: Type.t
  }

  defstruct [:var, :type]
end
