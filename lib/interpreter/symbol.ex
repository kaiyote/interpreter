defmodule Interpreter.Symbol do
  @moduledoc "A module that contains various Symbol types"

  alias Interpreter.Symbol.{BuiltInType, Var}

  @typedoc "All possible Symbol types"
  @type t :: BuiltInType.t | Var.t
end
