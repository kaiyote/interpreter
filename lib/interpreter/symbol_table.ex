defmodule Interpreter.SymbolTable do
  @moduledoc "The symbol table"

  alias Interpreter.Symbol
  alias Interpreter.Symbol.{BuiltInType, Var}
  alias Interpreter.Node.{Assign, BinOp, Block, Compound, NoOp, Num, Program, UnaryOp, VarDecl}
  alias Interpreter.Node.Var, as: NVar

  @ets_table :interpreter_symbol_table

  @doc """
  Creates the symbol table and prepopulates it w/ built in language constructs
  *Must* call this before calling `define` or `lookup`
  """
  @spec new() :: true
  def new do
    if @ets_table in :ets.all do
      :ets.delete_all_objects @ets_table
    else
      :ets.new @ets_table, [:ordered_set, :public, :named_table]
    end

    define %BuiltInType{name: :integer}
    define %BuiltInType{name: :real}
  end

  @doc """
  Adds/Updates a symbol in the table
  Will fail if `SymbolTable.new` has not been called previously
  """
  @spec define(Symbol.t) :: true
  def define(%{name: name} = symbol) do
    :ets.insert @ets_table, {name, symbol}
  end

  @doc """
  Retrieves a symbol from the symbol table
  Will fail if `SymbolTable.new` has not been called previously
  """
  @spec lookup(String.t) :: Symbol.t | nil
  def lookup(name) do
    case :ets.lookup @ets_table, name do
      [{^name, value}] -> value
      _ -> nil
    end
  end

  @doc "Walks the Symbol tree, ensuring variables exist before assignment"
  def visit(%Assign{ident: %{name: name}, value: value}) do
    case lookup name do
      nil -> raise "NameError(#{name})"
      _ -> visit value
    end
  end
  def visit(%BinOp{left: left, right: right}) do
    visit left
    visit right
  end
  def visit(%Block{declarations: declarations, compound_statement: statements}) do
    for decl <- declarations, do: visit(decl)
    visit statements
  end
  def visit(%Compound{children: children}) do
    for child <- children, do: visit(child)
  end
  def visit(%NVar{name: name}) do
    case lookup name do
      nil -> raise "NameError(#{name})"
      _ -> :ok
    end
  end
  def visit(%Program{block: block}) do
    true = new()
    visit block
  end
  def visit(%UnaryOp{expr: expr}) do
    visit expr
  end
  def visit(%VarDecl{type: %{value: t_val}, var: %{name: name}}) do
    type_symbol = lookup t_val
    var_symbol = %Var{name: name, type: type_symbol}
    define(var_symbol)
  end
  def visit(%Num{}) do
  end
  def visit(%NoOp{}) do
  end
end
