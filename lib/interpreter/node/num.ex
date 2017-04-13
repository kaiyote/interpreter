defmodule Interpreter.Node.Num do
  @moduledoc """
  A node that just contains a number

  Example:

      iex> %Interpreter.Node.Num{value: 3.14}
      %Interpreter.Node.Num{value: 3.14}

      iex> %Interpreter.Node.Num{value: 3}
      %Interpreter.Node.Num{value: 3}
  """

  @typedoc "The `Num` AST node"
  @type t :: %__MODULE__{value: number}

  defstruct [:value]
end
