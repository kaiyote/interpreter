defmodule Interpreter.Node.Program do
  @moduledoc "The root node for the pascal program."

  alias Interpreter.Node.Block

  @typedoc "The `Program` struct"
  @type t :: %__MODULE__{
    name: String.t,
    block: Block.t
  }

  defstruct name: "Program", block: %Block{}
end
