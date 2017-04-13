defmodule Interpreter.Node.Compound do
  @moduledoc ~S"""
  Represents a `BEGIN ... END` block

  Example:

      iex> %Interpreter.Node.Compound{children: (for x <- 1..2, do: %Interpreter.Node.Num{value: x})}
      %Interpreter.Node.Compound{children: [%Interpreter.Node.Num{value: 1}, %Interpreter.Node.Num{value: 2}]}
  """

  alias Interpreter.Node

  @type t :: %__MODULE__{children: [Node.t]}

  defstruct children: []
end
