defmodule Interpreter.Token do
  @moduledoc false
  alias Interpreter.Token

  defstruct [:type, :value]

  def token(type, value) when is_atom(type) do
    %Token{type: type, value: value}
  end
end

defimpl String.Chars, for: Interpreter.Token do
  def to_string(token) do
    "%Token{#{token.type}, #{token.value}}"
  end
end
