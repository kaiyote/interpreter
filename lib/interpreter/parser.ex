defmodule Interpreter.Parser do
  @moduledoc "The `Parser`. Turns a source string into an `Abstract Syntax Tree`"

  alias Interpreter.{Token, Lexer, Node}
  alias Interpreter.Node.{BinOp, Num, UnaryOp, Compound, Assign, NoOp, Var}

  @typedoc "The `Parser` Struct"
  @type t :: %__MODULE__{
    lexer: Lexer.t,
    current_token: Token.t
  }

  defstruct [:lexer, :current_token]

  @doc ~S"""
  Given a parser, generates the AST for the source

  Example:

      iex> Interpreter.Parser.parse "begin end."
      %Interpreter.Node.Compound{children: [%Interpreter.Node.NoOp{}]}
  """
  @spec parse(t | String.t) :: Node.t
  def parse(input) when is_binary(input) do
    input
    |> parser()
    |> parse()
  end
  def parse(parser) do
    {tree, parser} = program parser
    finish_parse parser, tree
  end

  @spec finish_parse(t, Compound.t) :: Compound.t
  defp finish_parse(%{current_token: %{type: type}}, tree) when type == :eof do
    tree
  end

  @spec parser(String.t) :: t
  defp parser(input) do
    {token, lexer} = Lexer.get_next_token input
    %__MODULE__{lexer: lexer, current_token: token}
  end

  @spec variable(t) :: {Var.t, t}
  defp variable(%{current_token: %{value: value}} = parser) do
    node = %Var{name: value}
    parser = eat parser, :id
    {node, parser}
  end

  @spec assignment_statement(t) :: {Assign.t, t}
  defp assignment_statement(parser) do
    {ident, parser} = variable parser
    parser = eat parser, :assign
    {val, parser} = expr parser
    {%Assign{ident: ident, value: val}, parser}
  end

  @spec statement(t) :: {Assign.t | Compound.t | NoOp.t, t}
  defp statement(%{current_token: %{type: :begin}} = parser) do
    compound_statement parser
  end
  defp statement(%{current_token: %{type: :id}} = parser) do
    assignment_statement parser
  end
  defp statement(parser) do
    {%NoOp{}, parser}
  end

  @spec statement_list(t, [Node.t]) :: {[Node.t], t}
  defp statement_list(parser, statements \\ [])
  defp statement_list(%{current_token: %{type: :semi}} = parser, statements) do
    {node, parser} = parser
      |> eat(:semi)
      |> statement()

    statement_list parser, [node | statements]
  end
  defp statement_list(parser, []) do
    {node, parser} = statement parser
    statement_list parser, [node]
  end
  defp statement_list(%{current_token: %{type: type}} = parser, statements) when type != :id do
    {Enum.reverse(statements), parser}
  end

  @spec compound_statement(t) :: {Compound.t, t}
  defp compound_statement(parser) do
    parser = eat parser, :begin
    {nodes, parser} = statement_list parser
    parser = eat parser, :end

    {%Compound{children: nodes}, parser}
  end

  @spec program(t) :: {Compound.t, t}
  defp program(parser) do
    {node, parser} = compound_statement parser
    parser = eat parser, :dot
    {node, parser}
  end

  @spec expr(t, Node.t | nil) :: {Node.t, t}
  defp expr(parser, tree \\ nil)
  defp expr(%{current_token: %{type: type}} = parser, nil) when type in ~w(plus minus)a do
    factor parser
  end
  defp expr(%{current_token: %{type: type}} = parser, tree) when type in ~w(plus minus)a do
    parser = eat parser, type
    {right, parser} = term parser
    tree = %BinOp{left: tree, op: type, right: right}
    expr parser, tree
  end
  defp expr(parser, nil) do
    {node, parser} = term parser
    expr parser, node
  end
  defp expr(parser, tree) do
    {tree, parser}
  end

  @spec term(t, Node.t | nil) :: {Node.t, t}
  defp term(parser, left \\ nil)
  defp term(%{current_token: %{type: type}} = parser, left) when type in ~w(mul div)a do
    parser = eat parser, type
    {right, parser} = factor parser
    node = %BinOp{left: left, op: type, right: right}
    term parser, node
  end
  defp term(parser, nil) do
    {node, parser} = factor parser
    term parser, node
  end
  defp term(parser, left) do
    {left, parser}
  end

  @spec factor(t) :: {Node.t, t}
  defp factor(%{current_token: %{type: type}} = parser) when type in ~w(plus minus)a do
    parser = eat parser, type
    {expr, parser} = factor parser
    {%UnaryOp{op: type, expr: expr}, parser}
  end
  defp factor(%{current_token: %{type: :integer, value: value}} = parser) do
    parser = eat parser, :integer
    {%Num{value: value}, parser}
  end
  defp factor(%{current_token: %{type: :lparen}} = parser) do
    parser = eat parser, :lparen
    {node, parser} = expr parser
    parser = eat parser, :rparen
    {node, parser}
  end
  defp factor(parser) do
    variable parser
  end

  @spec eat(t, Token.token_type) :: t
  defp eat(%{current_token: %{type: type}} = parser, token_type) when type == token_type do
    {token, lexer} = Lexer.get_next_token parser.lexer
    %{parser | lexer: lexer, current_token: token}
  end
end
