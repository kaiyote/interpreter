defmodule Interpreter.Node.Block do
  @moduledoc ~S"""
  Contains variable declarations and the compound statement that makes up the body of the block.

  Example:

      iex> alias Interpreter.Node.{Block, Compound, Var, VarDecl, Type}
      iex> %Block{}
      %Interpreter.Node.Block{compound_statement: %Interpreter.Node.Compound{children: []}, declarations: []}
  """

  alias Interpreter.Node.{Compound, VarDecl}

  @type t :: %__MODULE__{
    declarations: [VarDecl.t],
    compound_statement: Compound.t
  }

  defstruct declarations: [], compound_statement: %Compound{}
end
