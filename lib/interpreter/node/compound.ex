defmodule Interpreter.Node.Compound do
  @moduledoc ~S"""
  Represents a `BEGIN ... END` block

  Example:

      iex> alias Interpreter.Node.{Compound, Num}
      iex> compound = %Compound{children: (for x <- 1..3, do: Num.num(Interpreter.Token.token(:integer, x)))}
      iex> to_string compound
      "%Compound[%Num{1},\n%Num{2},\n%Num{3},\n]"
  """

  alias Interpreter.Node

  @type t :: %__MODULE__{
    children: [Node.t]
  }

  defstruct children: []
end

defimpl String.Chars, for: Interpreter.Node.Compound do
  def to_string(%{children: children}) do
    child_strings = Enum.map children, fn child -> Kernel.to_string(child) <> ",\n" end
    "%Compound[#{for str <- child_strings, do: str}]"
  end
end
