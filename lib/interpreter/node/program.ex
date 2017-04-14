defmodule Interpreter.Node.Program do
  @moduledoc ~S"""
  The root node for the pascal program.

  Example:

      iex> %Interpreter.Node.Program{}
      %Interpreter.Node.Program{block: %Interpreter.Node.Block{compound_statement: %Interpreter.Node.Compound{children: []}, declarations: []}, name: "Program"}
  """

  alias Interpreter.Node.Block

  @typedoc "The `Program` struct"
  @type t :: %__MODULE__{
    name: String.t,
    block: Block.t
  }

  defstruct name: "Program", block: %Block{}
end
