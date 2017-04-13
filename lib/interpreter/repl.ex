defmodule Interpreter.Repl do
  @moduledoc false

  @prompt "calc>> "

  def loop do
    case IO.gets @prompt do
      i when i in ["\n", "\r\n"] ->
        IO.puts "Goodbye"
        :ok
      input ->
        input
        |> Interpreter.interpret()
        |> IO.puts()

        loop()
    end
  end
end
