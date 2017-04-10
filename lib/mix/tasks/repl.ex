defmodule Mix.Tasks.Repl do
  use Mix.Task

  alias Interpreter.Repl

  def run(_) do
    IO.puts "Welcome to `interpreter`"
    IO.puts "Type some stuff, hit `CTRL-C` to quit"

    Repl.loop()
  end
end
