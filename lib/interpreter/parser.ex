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
  Given an input string, constructs a `Parser` queued up at the first source token

  Example:

      iex> %{current_token: t} = Interpreter.Parser.parser "42 + 7"
      iex> to_string t
      "%Token{integer, 42}"
  """
  @spec parser(String.t) :: t
  def parser(input) do
    lexer = Lexer.lexer input
    {token, lexer} = Lexer.get_next_token lexer
    %__MODULE__{lexer: lexer, current_token: token}
  end

  @spec term(t, node_type | nil) :: {node_type, t}
  defp term(%{current_token: %{type: type} = op} = parser, left)
       when type in ~w(mul div)a do

    parser = eat parser, type
    {right, parser} = factor parser
    node = BinOp.binop left, op, right
    term parser, node
  end
  defp term(parser, left \\ nil) do
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
