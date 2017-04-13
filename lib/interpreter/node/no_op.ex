defmodule Interpreter.Node.NoOp do
  @moduledoc ~S"""
  An empty AST node

  Example:

      iex> %Interpreter.Node.NoOp{}
      %Interpreter.Node.NoOp{}

      iex> %Interpreter.Node.NoOp{val: 6}
      ** (KeyError) key :val not found in: %Interpreter.Node.NoOp{}
               (stdlib) :maps.update(:val, 6, %Interpreter.Node.NoOp{})
          (interpreter) lib/interpreter/node/no_op.ex:6: anonymous fn/2 in Interpreter.Node.NoOp.__struct__/1
               (elixir) lib/enum.ex:1755: Enum."-reduce/3-lists^foldl/2-0-"/3
          (interpreter) expanding struct: Interpreter.Node.NoOp.__struct__/1
                        iex:1: (file)
  """

  @type t :: %__MODULE__{}

  defstruct []
end
