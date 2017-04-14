defmodule Interpreter.SymbolTable do
  @moduledoc "The symbol table"

  alias Interpreter.Symbol
  alias Interpreter.Symbol.BuiltInType

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
end
