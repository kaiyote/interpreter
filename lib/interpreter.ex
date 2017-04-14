defmodule Interpreter do
  @moduledoc "The main module. Pass a string to `Interpreter.interpret` to get the result"

  alias Interpreter.{Parser, Node}
  alias Interpreter.Node.{Assign, BinOp, Block, Compound, NoOp, Num, Program, Type, UnaryOp, Var,
                          VarDecl}

  @ets_table :global_scope

  @doc "Given a source string, interprets the AST generated from it"
  @spec interpret(String.t) :: any
  def interpret(input) do
    try do
      :ets.new @ets_table, [:set, :public, :named_table]
    rescue
      ArgumentError ->
        :ets.delete @ets_table
        :ets.new @ets_table, [:set, :public, :named_table]
    end

    input
    |> Parser.parse()
    |> visit()

    :ets.select @ets_table, [{:"$1", [], [:"$1"]}]
  end

  @spec visit(Node.t) :: any
  defp visit(%Assign{ident: %{name: name}, value: val}) do
    :ets.insert(@ets_table, {name, visit(val)})
  end
  defp visit(%BinOp{left: left, op: :plus, right: right}) do
    visit(left) + visit(right)
  end
  defp visit(%BinOp{left: left, op: :minus, right: right}) do
    visit(left) - visit(right)
  end
  defp visit(%BinOp{left: left, op: :mul, right: right}) do
    visit(left) * visit(right)
  end
  defp visit(%BinOp{left: left, op: :integer_div, right: right}) do
    div(visit(left), visit(right))
  end
  defp visit(%BinOp{left: left, op: :float_div, right: right}) do
    visit(left) / visit(right)
  end
  defp visit(%Block{declarations: dec_list, compound_statement: prog}) do
    for dec <- dec_list, do: visit(dec)
    visit prog
  end
  defp visit(%Compound{children: children}) do
    for child <- children, do: visit(child)
  end
  defp visit(%NoOp{}) do
  end
  defp visit(%Num{value: val}) do
    val
  end
  defp visit(%Program{block: block}) do
    visit block
  end
  defp visit(%Type{}) do
  end
  defp visit(%UnaryOp{op: :plus, expr: expr}) do
    +visit(expr)
  end
  defp visit(%UnaryOp{op: :minus, expr: expr}) do
    -visit(expr)
  end
  defp visit(%Var{name: name}) do
    case :ets.lookup @ets_table, name do
      [{^name, value}] -> value
    end
  end
  defp visit(%VarDecl{}) do
  end
end
