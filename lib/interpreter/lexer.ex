defmodule Interpreter.Lexer do
  @moduledoc false

  alias Interpreter.Token

  defmacrop is_digit(s) do
    quote do
      unquote(s) in ~w(0 1 2 3 4 5 6 7 8 9)
    end
  end

  defmacrop is_whitespace(s) do
    quote do
      unquote(s) in [" ", "\t", "\n", "\r"]
    end
  end

  def get_next_token(%Interpreter{current_char: nil} = interp) do
    %{interp | current_token: Token.token(:eof, nil)}
  end
  def get_next_token(%Interpreter{current_char: c} = interp)
    when is_whitespace(c) do

    interp
    |> skip_whitespace()
    |> get_next_token()
  end
  def get_next_token(%Interpreter{current_char: c} = interp)
    when is_digit(c) do

    integer interp
  end
  def get_next_token(%Interpreter{current_char: "+"} = interp) do
    interp
    |> advance()
    |> update_with_token(:plus, "+")
  end
  def get_next_token(%Interpreter{current_char: "-"} = interp) do
    interp
    |> advance()
    |> update_with_token(:minus, "-")
  end
  def get_next_token(%Interpreter{current_char: "*"} = interp) do
    interp
    |> advance()
    |> update_with_token(:mul, "*")
  end
  def get_next_token(%Interpreter{current_char: "/"} = interp) do
    interp
    |> advance()
    |> update_with_token(:div, "/")
  end
  def get_next_token(%Interpreter{current_char: "("} = interp) do
    interp
    |> advance()
    |> update_with_token(:lparen, "(")
  end
  def get_next_token(%Interpreter{current_char: ")"} = interp) do
    interp
    |> advance()
    |> update_with_token(:rparen, ")")
  end

  defp update_with_token(interp, type, value) when is_atom(type) do
    %{interp | current_token: Token.token(type, value)}
  end

  defp integer(interp, int_res \\ "")
  defp integer(%Interpreter{current_char: c} = interp, int_res)
    when is_digit(c) do

    interp
    |> advance()
    |> integer(int_res <> c)
  end
  defp integer(interp, int_res) do
    int_val = String.to_integer int_res
    %{interp | current_token: Token.token(:integer, int_val)}
  end

  defp skip_whitespace(%Interpreter{current_char: c} = interp)
    when is_whitespace(c) do

    interp
    |> advance()
    |> skip_whitespace()
  end
  defp skip_whitespace(interp), do: interp

  defp advance(%Interpreter{text: text, pos: pos} = interp) do
    new_pos = pos + 1
    %{interp | pos: new_pos, current_char: String.at(text, new_pos)}
  end
end
