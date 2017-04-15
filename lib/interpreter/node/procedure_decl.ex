defmodule Interpreter.Node.ProcedureDecl do
  @moduledoc "An AST node for a Procedure Declaration"

  alias Interpreter.Node.Block

  @typedoc "The `ProcedureDecl` struct"
  @type t :: %__MODULE__{
    name: String.t,
    block: Block.t
  }

  defstruct [:name, :block]
end
