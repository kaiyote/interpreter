defmodule Interpreter.Node.Assign do
  @moduledoc "An AST node representing an assignment statement"

  alias Interpreter.{Node, Token}
  alias Interpreter.Node.Var

  @type t :: %__MODULE__{
    ident: Var.t,
    op: Token.t,
    val: Node.t
  }

  defstruct [:ident, :op, :val]

  @doc ~S"""
  Given a Var node, an assignment token, and another node w/ a value of some sort
  produces an Assign node.

  Example:

      iex> alias Interpreter.Node.{Assign, Num, Var}
      iex> alias Interpreter.Token
      iex> assign = Assign.assign(%Var{name: "var1"}, Token.token(:assign, ":="), Num.num(Token.token(:integer, 3)))
      iex> to_string assign
      "%Assign{var1 => %Num{3}}"
  """
  @spec assign(Var.t, Token.t, Node.t) :: t
  def assign(ident, op, val) do
    %__MODULE__{ident: ident, op: op, val: val}
  end
end

defimpl String.Chars, for: Interpreter.Node.Assign do
  def to_string(%{ident: ident, val: val, op: _}) do
    "%Assign{#{Kernel.to_string ident} => #{Kernel.to_string val}}"
  end
end
