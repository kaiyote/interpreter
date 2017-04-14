defmodule Interpreter.Symbol.Var do
  @moduledoc "A Symbol for variables"

  alias Interpreter.Symbol.BuiltInType

  @typedoc "The `Var` symbol struct"
  @type t :: %__MODULE__{
    name: String.t,
    type: BuiltInType.t
  }

  defstruct [:name, :type]
end
