defmodule Interpreter.Node.Num do
  @moduledoc "A node that just contains a number"

  @typedoc "The `Num` AST node"
  @type t :: %__MODULE__{value: number}

  defstruct [:value]
end
