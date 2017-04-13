defmodule Interpreter.Node.Var do
  @moduledoc ~S"""
  An AST node for a Variable.

  Example:

    iex> to_string %Interpreter.Node.Var{name: "varName"}
    "varName"
  """

  @type t :: %__MODULE__{
    name: String.t
  }

  defstruct [:name]
end

defimpl String.Chars, for: Interpreter.Node.Var do
  def to_string(%{name: name}) do
    name
  end
end
