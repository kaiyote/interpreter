defmodule Interpreter do
  @moduledoc false

  alias Interpreter.{Lexer, Token}

  defstruct text: nil, pos: 0, current_token: nil, current_char: nil

  def interpreter(input) do
    trimmed = String.trim input
    first_char = String.at trimmed, 0
    Lexer.get_next_token %Interpreter{text: trimmed, current_char: first_char}
  end

  def expr(interp, result \\ nil)
  def expr(%{current_token: %{type: :plus}} = interp, result) do
    interp = eat interp, :plus
    {right_side, interp} = term interp
    expr(interp, result + right_side)
  end
  def expr(%{current_token: %{type: :minus}} = interp, result) do
    interp = eat interp, :minus
    {right_side, interp} = term interp
    expr(interp, result - right_side)
  end
  def expr(interp, nil) do
    {result, interp} = term interp
    expr interp, result
  end
  def expr(interp, result) do
    {result, interp}
  end

  defp term(interp, result \\ nil)
  defp term(%{current_token: %{type: :mul}} = interp, result) do
    interp = eat interp, :mul
    {right_side, interp} = factor interp
    term(interp, result * right_side)
  end
  defp term(%{current_token: %{type: :div}} = interp, result) do
    interp = eat interp, :div
    {right_side, interp} = factor interp
    term(interp, result / right_side)
  end
  defp term(interp, nil) do
    {result, interp} = factor interp
    term interp, result
  end
  defp term(interp, result) do
    {result, interp}
  end

  defp factor(%{current_token: %{type: :integer} = token} = interp) do
    interp = eat interp, :integer
    {token.value, interp}
  end
  defp factor(%{current_token: %{type: :lparen}} = interp) do
    interp = eat interp, :lparen
    {result, interp} = expr interp
    interp = eat interp, :rparen
    {result, interp}
  end

  defp eat(%Interpreter{current_token: %Token{type: type}} = interp, tok_type)
    when type == tok_type and is_atom(tok_type) do

    Lexer.get_next_token interp
  end
end
