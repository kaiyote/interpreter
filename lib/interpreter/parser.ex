defmodule Interpreter.Parser do
  @moduledoc false

  alias Interpreter.{Token, Lexer}
  alias Interpreter.Node.{Num, BinOp}

  @typedoc "The possible types of Nodes"
  @type node_type :: Num.t | BinOp.t

  @typedoc "The `Parser` Struct"
  @type t :: %__MODULE__{
    lexer: Lexer.t,
    current_token: Token.t
  }

  defstruct [:lexer, :current_token]

  @doc ~S"""
  Given a parser, generates the AST for the source

  Example:

      iex> tree = Interpreter.Parser.parse "1 - 1"
      iex> to_string tree
      "%BinOp{%Num{1} - %Num{1}}"
  """
  @spec parse(t | String.t) :: node_type
  def parse(input) when is_binary(input) do
    input
    |> parser()
    |> parse()
  end
  def parse(parser) do
    {tree, _} = expr parser
    tree
  end

  @spec parser(String.t) :: t
  defp parser(input) do
    {token, lexer} = Lexer.get_next_token input
    %__MODULE__{lexer: lexer, current_token: token}
  end

  @spec expr(t, node_type | nil) :: {node_type, t}
  defp expr(parser, tree \\ nil)
  defp expr(%{current_token: %{type: type} = op} = parser, tree) when type in ~w(plus minus)a do
    parser = eat parser, type
    {right, parser} = term parser
    tree = BinOp.binop tree, op, right
    expr parser, tree
  end
  defp expr(parser, nil) do
    {node, parser} = term parser
    expr parser, node
  end
  defp expr(parser, tree) do
    {tree, parser}
  end

  @spec term(t, node_type | nil) :: {node_type, t}
  defp term(parser, left \\ nil)
  defp term(%{current_token: %{type: type} = op} = parser, left) when type in ~w(mul div)a do
    parser = eat parser, type
    {right, parser} = factor parser
    node = BinOp.binop left, op, right
    term parser, node
  end
  defp term(parser, nil) do
    {node, parser} = factor parser
    term parser, node
  end
  defp term(parser, left) do
    {left, parser}
  end

  @spec factor(t) :: {node_type, t}
  defp factor(%{current_token: %{type: :integer} = token} = parser) do
    parser = eat parser, :integer
    {Num.num(token), parser}
  end
  defp factor(%{current_token: %{type: :lparen}} = parser) do
    parser = eat parser, :lparen
    {node, parser} = expr parser
    parser = eat parser, :rparen
    {node, parser}
  end

  @spec eat(t, Token.token_type) :: t
  defp eat(%{current_token: %{type: type}} = parser, token_type) when type == token_type do
    {token, lexer} = Lexer.get_next_token parser.lexer
    %{parser | lexer: lexer, current_token: token}
  end
end
