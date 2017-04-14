defmodule Interpreter.Node.Var do
  @moduledoc "An AST node for a Variable."

  @typedoc "The `Var` struct"
  @type t :: %__MODULE__{name: String.t}

  defstruct [:name]
end
