defmodule Interpreter do
  @moduledoc "The main module. Pass a string to `Interpreter.interpret` to get the result"

  alias Interpreter.{Parser, Node}
  alias Interpreter.Node.{Assign, BinOp, Compound, NoOp, Num, UnaryOp, Var}

  @ets_table :global_scope

  @doc ~S"""
  Given a source string, computes the arithmetic for it

  Examples:

      iex> Interpreter.interpret "BEGIN x := 11; END."
      [{"x", 11}]
  """
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
  defp visit(%Num{value: val}), do: val
  defp visit(%BinOp{left: left, op: %{type: :plus}, right: right}) do
    visit(left) + visit(right)
  end
  defp visit(%BinOp{left: left, op: %{type: :minus}, right: right}) do
    visit(left) - visit(right)
  end
  defp visit(%BinOp{left: left, op: %{type: :mul}, right: right}) do
    visit(left) * visit(right)
  end
  defp visit(%BinOp{left: left, op: %{type: :div}, right: right}) do
    visit(left) / visit(right)
  end
  defp visit(%UnaryOp{op: %{type: :plus}, expr: expr}) do
    +visit(expr)
  end
  defp visit(%UnaryOp{op: %{type: :minus}, expr: expr}) do
    -visit(expr)
  end
  defp visit(%Assign{ident: %{name: name}, value: val}) do
    :ets.insert(@ets_table, {name, visit(val)})
  end
  defp visit(%Compound{children: children}) do
    for child <- children, do: visit(child)
  end
  defp visit(%Var{name: name}) do
    case :ets.lookup @ets_table, name do
      [{^name, value}] -> value
    end
  end
  defp visit(%NoOp{}) do
  end
end
