defmodule Interpreter.Node.Assign do
  @moduledoc ~S"""
  An AST node representing an assignment statement

  Example:

      iex> alias Interpreter.Node.{Assign, Var, Num}
      iex> %Assign{ident: %Var{name: "x"}, value: %Num{value: 1}}
      %Interpreter.Node.Assign{ident: %Interpreter.Node.Var{name: "x"}, value: %Interpreter.Node.Num{value: 1}}
  """

  alias Interpreter.Node
  alias Interpreter.Node.Var

  @type t :: %__MODULE__{
    ident: Var.t,
    value: Node.t
  }

  defstruct [:ident, :value]
end
