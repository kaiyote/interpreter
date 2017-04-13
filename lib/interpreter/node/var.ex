defmodule Interpreter.Node.Var do
  @moduledoc ~S"""
  An AST node for a Variable.

  Example:

    iex> %Interpreter.Node.Var{name: "varName"}
    %Interpreter.Node.Var{name: "varName"}

    iex> %Interpreter.Node.Var{}
    %Interpreter.Node.Var{name: nil}
  """

  @type t :: %__MODULE__{name: String.t}

  defstruct [:name]
end
