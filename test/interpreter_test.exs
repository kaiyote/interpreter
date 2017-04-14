defmodule InterpreterTest do
  @moduledoc false

  use ExUnit.Case, async: true

  test "Interpreter can correctly interpret a program" do
    test_prog = "
    PROGRAM Part10;
    VAR
      number     : INTEGER;
      a, b, c, x : INTEGER;
      y          : REAL;

    BEGIN {Part10}
      BEGIN
          number := 2;
          a := number;
          b := 10 * a + 10 * number DIV 4;
          c := a - - b
      END;
      x := 11;
      y := 20 / 7 + 3.14;
      { writeln('a = ', a); }
      { writeln('b = ', b); }
      { writeln('c = ', c); }
      { writeln('number = ', number); }
      { writeln('x = ', x); }
      { writeln('y = ', y); }
    END.  {Part10}
    "
    results = Interpreter.interpret test_prog
    assert results == [{"x", 11}, {"b", 25}, {"number", 2}, {"c", 27}, {"y", 5.997142857142857}, {"a", 2}]
  end
end
