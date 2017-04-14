defmodule Interpreter.Node.NoOp do
  @moduledoc "An empty AST node"

  @typedoc "The `Empty`/`NoOp` struct"
  @type t :: %__MODULE__{}

  defstruct []
end
