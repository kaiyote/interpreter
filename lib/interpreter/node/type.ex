defmodule Interpreter.Node.Type do
  @moduledoc ~S"""
  A variable `type` AST node

  Example:

      iex> %Interpreter.Node.Type{value: :integer}
      %Interpreter.Node.Type{value: :integer}
  """

  @typedoc "The `Type` struct"
  @type t :: %__MODULE__{
    value: :integer | :real
  }

  defstruct [:value]
end
