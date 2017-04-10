defmodule Interpreter do
  @moduledoc false
  alias Interpreter.{Token}

  defstruct text: nil, pos: 0, current_token: nil, current_char: nil

  defmacro is_digit(s) do
    quote do
      unquote(s) in ~w(0 1 2 3 4 5 6 7 8 9)
    end
  end

  def interpreter(input) do
    trimmed = String.trim input
    first_char = String.at trimmed, 0
    %Interpreter{text: trimmed, current_char: first_char}
  end

  def expr(interp) do
    interp = get_next_token interp

    left = interp.current_token
    interp = eat interp, :integer

    op = interp.current_token
    interp = eat interp, op.type

    right = interp.current_token
    %{current_token: %{type: :eof, value: nil}} = eat interp, :integer

    if op.type == :plus do
      left.value + right.value
    else
      left.value - right.value
    end
  end

  defp eat(%Interpreter{current_token: %Token{type: type}} = interp, tok_type)
    when type == tok_type and is_atom(tok_type) do

    get_next_token interp
  end

  defp get_next_token(%Interpreter{current_char: nil} = interp) do
    %{interp | current_token: Token.token(:eof, nil)}
  end
  defp get_next_token(%Interpreter{current_char: " "} = interp) do
    interp
    |> skip_whitespace()
    |> get_next_token()
  end
  defp get_next_token(%Interpreter{current_char: c} = interp)
    when is_digit(c) do

    integer interp
  end
  defp get_next_token(%Interpreter{current_char: "+"} = interp) do
    interp
    |> advance()
    |> (fn(i) -> %{i | current_token: Token.token(:plus, "+")} end).()
  end
  defp get_next_token(%Interpreter{current_char: "-"} = interp) do
    interp
    |> advance()
    |> (fn(i) -> %{i | current_token: Token.token(:minus, "-")} end).()
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

  defp skip_whitespace(%Interpreter{current_char: " "} = interp) do
    interp
    |> advance()
    |> skip_whitespace()
  end
  defp skip_whitespace(interp), do: interp

  defp advance(%Interpreter{text: text, pos: pos} = interp) do
    new_pos = pos + 1
    case String.at text, new_pos do
      nil -> %{interp | current_char: nil}
      c -> %{interp | pos: new_pos, current_char: c}
    end
  end
end
