defmodule InterpreterTest do
  use ExUnit.Case
  doctest Interpreter

  test "the truth" do
    assert 1 + 1 == 2
  end
end
