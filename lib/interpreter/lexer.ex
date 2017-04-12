defmodule Interpreter.Lexer do
  @moduledoc false

  alias Interpreter.Token

  @typedoc "The `Lexer` Struct"
  @type t :: %__MODULE__{
    text: String.t | nil,
    pos: integer,
    current_char: String.t | nil
  }

  defstruct [:text, :pos, :current_char]

  defmacrop is_digit(s) do
    quote do
      unquote(s) in ~w(0 1 2 3 4 5 6 7 8 9)
    end
  end

  defmacrop is_whitespace(s) do
    quote do
      unquote(s) in [" ", "\t", "\n", "\r"]
    end
  end

  @doc ~S"""
  Takes an untrimmed input string, and constructs a `Lexer` struct from it

  Examples:

      iex> Interpreter.Lexer.lexer " leading ws"
      %Interpreter.Lexer{text: "leading ws", pos: 0, current_char: "l"}

      iex> Interpreter.Lexer.lexer "trailing ws "
      %Interpreter.Lexer{text: "trailing ws", pos: 0, current_char: "t"}

      iex> Interpreter.Lexer.lexer "        "
      %Interpreter.Lexer{text: "", pos: 0, current_char: nil}
  """
  @spec lexer(String.t) :: t
  def lexer(input) do
    input = String.trim input
    first_char = String.at input, 0
    %__MODULE__{text: input, pos: 0, current_char: first_char}
  end

  @doc ~S"""
  Takes in a `Lexer`, and returns a tuple of the next `Token` and the updated `Lexer`
  It also handles skipping whitespace.
  Examples:

      iex> lexer = %Interpreter.Lexer{text: "1    +", pos: 1, current_char: " "}
      iex> {token, %{pos: x, current_char: c}} = Interpreter.Lexer.get_next_token lexer
      iex> "#{to_string token}, #{x}, #{c}"
      "%Token{plus, +}, 6, "

      iex> lexer = %Interpreter.Lexer{text: "42", pos: 0, current_char: "4"}
      iex> {token, %{pos: x, current_char: c}} = Interpreter.Lexer.get_next_token lexer
      iex> "#{to_string token}, #{x}, #{c}"
      "%Token{integer, 42}, 2, "

      iex> lexer = %Interpreter.Lexer{text: "42 -24", pos: 2, current_char: " "}
      iex> {token, %{pos: x, current_char: c}} = Interpreter.Lexer.get_next_token lexer
      iex> "#{to_string token}, #{x}, #{c}"
      "%Token{minus, -}, 4, 2"
  """
  @spec get_next_token(t) :: {Token.t, t}
  def get_next_token(%{current_char: nil} = lexer) do
    {Token.token(:eof, nil), lexer}
  end
  def get_next_token(%{current_char: c} = lexer) when is_whitespace(c) do
    lexer
    |> skip_whitespace()
    |> get_next_token()
  end
  def get_next_token(%{current_char: c} = lexer) when is_digit(c) do
    integer lexer
  end
  def get_next_token(%{current_char: c} = lexer) do
    {c |> convert_char_to_atom() |> Token.token(c), advance lexer}
  end

  @spec integer(t, String.t) :: {Token.t, t}
  defp integer(lexer, int_res \\ "")
  defp integer(%{current_char: c} = lexer, int_res) when is_digit(c) do
    lexer
    |> advance()
    |> integer(int_res <> c)
  end
  defp integer(lexer, int_res) do
    int_val = String.to_integer int_res
    {Token.token(:integer, int_val), lexer}
  end

  @spec convert_char_to_atom(String.t) :: Token.token_type
  defp convert_char_to_atom(char) when char in ~w|+ - * / ( )| do
    case char do
      "+" -> :plus
      "-" -> :minus
      "*" -> :mul
      "/" -> :div
      "(" -> :lparen
      ")" -> :rparen
    end
  end

  @spec skip_whitespace(t) :: t
  defp skip_whitespace(%{current_char: c} = lexer) when is_whitespace(c) do
    lexer
    |> advance()
    |> skip_whitespace()
  end
  defp skip_whitespace(lexer), do: lexer

  @spec advance(t) :: t
  defp advance(%{text: text, pos: pos} = lexer) do
    new_pos = pos + 1
    %{lexer | pos: new_pos, current_char: String.at(text, new_pos)}
  end
end
