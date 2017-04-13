defmodule Interpreter.Node do
  @moduledoc "A module that contains various AST Node types"

  alias Interpreter.Node.{Num, BinOp, UnaryOp}

  @typedoc "The various types of AST Nodes"
  @type t :: Num.t | BinOp.t | UnaryOp.t

  @typedoc "The types of Leaf nodes (have no children)"
  @type leaf_nodes :: Num.t
end
