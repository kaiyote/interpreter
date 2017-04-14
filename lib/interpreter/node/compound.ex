defmodule Interpreter.Node.Compound do
  @moduledoc "Represents a `BEGIN ... END` block"

  alias Interpreter.Node

  @typedoc "The `Compound` struct"
  @type t :: %__MODULE__{children: [Node.t]}

  defstruct children: []
end
