defmodule Interpreter.Node.Type do
  @moduledoc "A variable `type` AST node"

  @typedoc "The `Type` struct"
  @type t :: %__MODULE__{
    value: :integer | :real
  }

  defstruct [:value]
end
