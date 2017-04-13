defmodule Interpreter.Node.NoOp do
  @moduledoc "An empty AST node"

  @type t :: %__MODULE__{}

  defstruct []
end

defimpl String.Chars, for: Interpreter.Node.NoOp do
  def to_string(_), do: ""
end
