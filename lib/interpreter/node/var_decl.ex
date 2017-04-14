defmodule Interpreter.Node.VarDecl do
  @moduledoc ~S"""
  A variable declaration node

  Examples:

      iex> alias Interpreter.Node.{Var, VarDecl, Type}
      iex> %VarDecl{var: %Var{name: "x"}, type: %Type{value: :real}}
      %Interpreter.Node.VarDecl{type: %Interpreter.Node.Type{value: :real}, var: %Interpreter.Node.Var{name: "x"}}
  """

  alias Interpreter.Node.{Type, Var}

  @typedoc "The `VarDecl` struct"
  @type t :: %__MODULE__{
    var: Var.t,
    type: Type.t
  }

  defstruct [:var, :type]
end
