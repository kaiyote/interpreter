defmodule Interpreter do
  @moduledoc false
  alias Interpreter.{Token}

  defstruct text: "", pos: 0, current_token: nil

  def interpreter(input) do
    trimmed = String.trim input
    %Interpreter{text: trimmed}
  end

  def expr(interp) do
    interp = get_next_token interp

    left = interp.current_token
    interp = eat interp, :integer

    op = interp.current_token
    interp = eat interp, :plus

    right = interp.current_token
    %{current_token: %{type: :eof, value: nil}} = eat interp, :integer

    left.value + right.value
  end

  defp eat(%Interpreter{current_token: %Token{type: type}} = interp, tok_type)
    when type == tok_type do

    get_next_token interp
  end

  defp get_next_token(%Interpreter{text: text, pos: pos} = interp) do
    case String.at text, pos do
      nil ->
        %{interp | current_token: Token.token(:eof, nil)}
      c when c in ~w(0 1 2 3 4 5 6 7 8 9) ->
        %{interp | pos: pos + 1,
                   current_token: Token.token(:integer, String.to_integer(c))}
      c when c == "+" ->
        %{interp | pos: pos + 1,
                   current_token: Token.token(:plus, c)}
    end
  end
end
