defmodule Interpreter do
  @moduledoc "The main module. Pass a string to `Interpreter.interpret` to get the result"

  alias Interpreter.Parser
  alias Interpreter.Node

  @doc ~S"""
  Given a source string, computes the arithmetic for it

  Examples:

      iex> Interpreter.interpret "7 + 3 * (10 / (12 / (3 + 1) - 1))"
      22.0

      iex> Interpreter.interpret "7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)"
      10.0

      iex> Interpreter.interpret "7 + (((3 + 2)))"
      12

      iex> Interpreter.interpret "- 3"
      -3

      iex> Interpreter.interpret "+ 3"
      3

      iex> Interpreter.interpret "5 - - - + - 3"
      8

      iex> Interpreter.interpret "5 - - - + - (3 + 4) - +2"
      10
  """
  @spec interpret(String.t) :: any
  def interpret(input) do
    input
    |> Parser.parse()
    |> visit()
  end

  @spec visit(Node.t) :: any
  defp visit(%{value: val}), do: val
  defp visit(%{left: left, op: %{type: :plus}, right: right}) do
    visit(left) + visit(right)
  end
  defp visit(%{left: left, op: %{type: :minus}, right: right}) do
    visit(left) - visit(right)
  end
  defp visit(%{left: left, op: %{type: :mul}, right: right}) do
    visit(left) * visit(right)
  end
  defp visit(%{left: left, op: %{type: :div}, right: right}) do
    visit(left) / visit(right)
  end
  defp visit(%{op: %{type: :plus}, expr: expr}) do
    +visit(expr)
  end
  defp visit(%{op: %{type: :minus}, expr: expr}) do
    -visit(expr)
  end
end
