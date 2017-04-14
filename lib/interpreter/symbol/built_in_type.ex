defmodule Interpreter.Symbol.BuiltInType do
  @moduledoc "A Symbol for Built In Types"

  @typedoc "The `BuiltInType` symbol struct"
  @type t :: %__MODULE__{
    name: :integer | :real
  }

  defstruct [:name]
end
