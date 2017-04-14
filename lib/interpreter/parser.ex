defmodule Interpreter.Parser do
  @moduledoc "The `Parser`. Turns a source string into an `Abstract Syntax Tree`"

  alias Interpreter.{Token, Lexer, Node}
  alias Interpreter.Node.{Assign, BinOp, Block, Compound, NoOp, Num, Program, Type, UnaryOp, Var, VarDecl}

  @typedoc "The `Parser` Struct"
  @type t :: %__MODULE__{
    lexer: Lexer.t,
    current_token: Token.t
  }

  defstruct [:lexer, :current_token]

  @doc ~S"""
  Given a parser, generates the AST for the source

  Example:

      iex> Interpreter.Parser.parse "program x; begin end."
      %Interpreter.Node.Program{block: %Interpreter.Node.Block{compound_statement: %Interpreter.Node.Compound{children: [%Interpreter.Node.NoOp{}]}, declarations: []}, name: "x"}
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

  @spec eat(t, Token.token_type) :: t
  defp eat(%{current_token: %{type: type}} = parser, token_type) when type == token_type do
    {token, lexer} = Lexer.get_next_token parser.lexer
    %{parser | lexer: lexer, current_token: token}
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

  # ###########################################
  # AST Node generators (in alphabetical order)
  # ###########################################

  @spec assignment_statement(t) :: {Assign.t, t}
  defp assignment_statement(parser) do
    {ident, parser} = variable parser
    parser = eat parser, :assign
    {val, parser} = expr parser
    {%Assign{ident: ident, value: val}, parser}
  end

  @spec block(t) :: {Block.t, t}
  defp block(parser) do
    {declarations, parser} = declarations parser
    {compound_statement, parser} = compound_statement parser
    {%Block{declarations: declarations, compound_statement: compound_statement}, parser}
  end

  @spec compound_statement(t) :: {Compound.t, t}
  defp compound_statement(parser) do
    parser = eat parser, :begin
    {nodes, parser} = statement_list parser
    parser = eat parser, :end

    {%Compound{children: nodes}, parser}
  end

  @spec declarations(t, Node.declaration_list) :: {Node.declaration_list, t}
  defp declarations(parser, dec_list \\ [])
  defp declarations(%{current_token: %{type: :var}} = parser, []) do
    parser = eat parser, :var
    declarations parser
  end
  defp declarations(%{current_token: %{type: :id}} = parser, dec_list) do
    {var_decl, parser} = variable_declaration parser
    parser = eat parser, :semi
    declarations(parser, dec_list ++ var_decl)
  end
  defp declarations(parser, dec_list) do
    {dec_list, parser}
  end

  @spec program(t) :: {Program.t, t}
  defp program(parser) do
    parser = eat parser, :program
    {%{name: prog_name}, parser} = variable parser
    parser = eat parser, :semi
    {block, parser} = block parser
    prog_node = %Program{name: prog_name, block: block}
    parser = eat parser, :dot
    {prog_node, parser}
  end

  @spec statement(t) :: {Node.statement, t}
  defp statement(%{current_token: %{type: :begin}} = parser) do
    compound_statement parser
  end
  defp statement(%{current_token: %{type: :id}} = parser) do
    assignment_statement parser
  end
  defp statement(parser) do
    {%NoOp{}, parser}
  end

  @spec statement_list(t, Node.statement_list) :: {Node.statement_list, t}
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

  @spec variable(t) :: {Var.t, t}
  defp variable(%{current_token: %{value: value}} = parser) do
    node = %Var{name: value}
    parser = eat parser, :id
    {node, parser}
  end

  @spec variable_declaration(t, [Var.t]) :: {Node.declaration_list, t}
  defp variable_declaration(parser, dec_list \\ [])
  defp variable_declaration(%{current_token: %{type: :comma}} = parser, dec_list) do
    parser = eat parser, :comma
    var = %Var{name: parser.current_token.value}
    parser = eat parser, :id
    variable_declaration parser, [var | dec_list]
  end
  defp variable_declaration(parser, []) do
    nodes = [%Var{name: parser.current_token.value}]
    parser = eat parser, :id
    variable_declaration parser, nodes
  end
  defp variable_declaration(parser, dec_list) do
    parser = eat parser, :colon
    {type, parser} = type_spec parser
    var_decls = for var <- Enum.reverse(dec_list), do: %VarDecl{var: var, type: type}
    {var_decls, parser}
  end

  @spec type_spec(t) :: {Type.t, t}
  defp type_spec(%{current_token: %{type: type}} = parser) when type in ~w(integer real)a do
    parser = eat parser, type
    {%Type{value: type}, parser}
  end

  # #############################
  # Math solvers
  # #############################

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

  @spec factor(t) :: {Node.t, t}
  defp factor(%{current_token: %{type: type}} = parser) when type in ~w(plus minus)a do
    parser = eat parser, type
    {expr, parser} = factor parser
    {%UnaryOp{op: type, expr: expr}, parser}
  end
  defp factor(%{current_token: %{type: type, value: value}} = parser)
       when type in ~w(integer_const real_const)a do

    parser = eat parser, type
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

  @spec term(t, Node.t | nil) :: {Node.t, t}
  defp term(parser, left \\ nil)
  defp term(parser, nil) do
    {node, parser} = factor parser
    term parser, node
  end
  defp term(%{current_token: %{type: type}} = parser, left)
       when type in ~w(mul integer_div float_div)a do

    parser = eat parser, type
    {right, parser} = factor parser
    node = %BinOp{left: left, op: type, right: right}
    term parser, node
  end
  defp term(parser, left) do
    {left, parser}
  end
end
