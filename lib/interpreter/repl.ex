defmodule Interpreter.Repl do
  @moduledoc false

  @prompt "calc>> "

  def loop do
    @prompt
    |> IO.gets
    |> Interpreter.interpreter
    |> Interpreter.expr
    |> IO.puts

    loop()
  end
end
