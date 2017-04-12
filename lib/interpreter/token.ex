defmodule Interpreter.Token do
  @moduledoc false
  alias Interpreter.Token

  defstruct [:type, :value]

  defmacrop is_valid_type(a) do
    quote do
      unquote(a) in ~w(integer plus minus mul div lparen rparen eof)a
    end
  end

  def token(type, value) when is_valid_type(type) do
    %Token{type: type, value: value}
  end
end

defimpl String.Chars, for: Interpreter.Token do
  def to_string(token) do
    "%Token{#{token.type}, #{token.value}}"
  end
end
