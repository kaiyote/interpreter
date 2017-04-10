defmodule Interpreter do
  @moduledoc false
  alias Interpreter.{Lexer, Token}

  defstruct text: nil, pos: 0, current_token: nil, current_char: nil

  def interpreter(input) do
    trimmed = String.trim input
    first_char = String.at trimmed, 0
    %Interpreter{text: trimmed, current_char: first_char}
  end

  def expr(interp, result \\ 0)
  def expr(%{current_token: %{type: :eof}}, result) do
    result
  end
  def expr(%{current_token: %{type: :plus}} = interp, result) do
    interp = eat interp, :plus
    {res, interp} = term interp
    expr(interp, result + res)
  end
  def expr(%{current_token: %{type: :minus}} = interp, result) do
    interp = eat interp, :minus
    {res, interp} = term interp
    expr(interp, result - res)
  end
  def expr(interp, 0) do
    interp = Lexer.get_next_token interp

    {result, interp} = term interp
    expr interp, result
  end

  defp term(%Interpreter{current_token: token} = interp) do
    {token.value, eat(interp, :integer)}
  end

  defp eat(%Interpreter{current_token: %Token{type: type}} = interp, tok_type)
    when type == tok_type and is_atom(tok_type) do

    Lexer.get_next_token interp
  end
end
