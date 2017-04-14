defmodule Interpreter.Node.Block do
  @moduledoc "Contains variable declarations and the compound statement that makes up the body of the block."

  alias Interpreter.Node.{Compound, VarDecl}

  @typedoc "The `Block` struct"
  @type t :: %__MODULE__{
    declarations: [VarDecl.t],
    compound_statement: Compound.t
  }

  defstruct declarations: [], compound_statement: %Compound{}
end
