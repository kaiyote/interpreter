defmodule Interpreter.Node do
  @moduledoc "A module that contains various AST Node types"

  alias Interpreter.Node.{Num, BinOp, UnaryOp, Compound, Assign, Var, NoOp}

  @typedoc "The various types of AST Nodes"
  @type t :: Num.t | BinOp.t | UnaryOp.t | Compound.t | Assign.t | Var.t | NoOp.t

  @typedoc "The types of Leaf nodes (have no children)"
  @type leaf_nodes :: Num.t | Var.t | NoOp.t
end
