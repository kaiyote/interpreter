defmodule Interpreter.Node do
  @moduledoc "A module that contains various AST Node types"

  alias Interpreter.Node.{Assign, BinOp, Block, Compound, NoOp, Num, Program, Type, UnaryOp, Var,
                          VarDecl}

  @typedoc "The various types of AST Nodes"
  @type t :: Assign.t | BinOp.t | Block.t | Compound.t | NoOp.t | Num.t | Program.t | Type.t |
             UnaryOp.t | Var.t | VarDecl.t

  @typedoc "The types of Leaf nodes (have no children)"
  @type leaf_nodes :: NoOp.t | Num.t | Type.t | Var.t

  @typedoc "The various types of `statement`"
  @type statement :: Assign.t | Compound.t | NoOp.t

  @typedoc "Exactly what the type name says it is...."
  @type statement_list :: [statement]

  @typedoc "Exactly what the type name says it is...."
  @type declaration_list :: [VarDecl.t]
end
