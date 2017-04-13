defmodule Interpreter.Lexer do
  @moduledoc "The `Lexer`. Turns a source string into a stream of `Token`s"

  alias Interpreter.Token

  @typedoc "The `Lexer` Struct"
  @type t :: %__MODULE__{
    text: String.t | nil,
    pos: integer,
    current_char: String.t | nil,
    next_char: String.t | nil
  }

  defstruct [:text, :pos, :current_char, :next_char]

  defmacrop is_digit(s) do
    quote do
      unquote(s) in ~w(0 1 2 3 4 5 6 7 8 9)
    end
  end

  defmacrop is_alpha(s) do
    quote do
      unquote(s) in ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    end
  end

  defmacrop is_alphanum(s) do
    quote do
      is_digit(unquote(s)) or is_alpha(unquote(s))
    end
  end

  defmacrop is_whitespace(s) do
    quote do
      unquote(s) in [" ", "\t", "\n", "\r"]
    end
  end

  @doc ~S"""
  Takes in a `Lexer`, and returns a tuple of the next `Token` and the updated `Lexer`
  It also handles skipping whitespace.

  Examples:

      iex> lexer = %Interpreter.Lexer{text: "1    +", pos: 1, current_char: " ", next_char: " "}
      iex> {token, %{pos: x, current_char: c}} = Interpreter.Lexer.get_next_token lexer
      iex> "#{to_string token}, #{x}, #{c}"
      "%Token{plus, +}, 6, "

      iex> lexer = %Interpreter.Lexer{text: "42", pos: 0, current_char: "4", next_char: "2"}
      iex> {token, %{pos: x, current_char: c}} = Interpreter.Lexer.get_next_token lexer
      iex> "#{to_string token}, #{x}, #{c}"
      "%Token{integer, 42}, 2, "

      iex> lexer = %Interpreter.Lexer{text: "42 -24", pos: 2, current_char: " ", next_char: "-"}
      iex> {token, %{pos: x, current_char: c}} = Interpreter.Lexer.get_next_token lexer
      iex> "#{to_string token}, #{x}, #{c}"
      "%Token{minus, -}, 4, 2"

      iex> {token, %{pos: x, current_char: c}} = Interpreter.Lexer.get_next_token "4 - 2"
      iex> "#{to_string token}, #{x}, #{c}"
      "%Token{integer, 4}, 1,  "
  """
  @spec get_next_token(t | String.t) :: {Token.t, t}
  def get_next_token(input) when is_binary(input) do
    input
    |> lexer
    |> get_next_token()
  end
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
  def get_next_token(%{current_char: c} = lexer) when is_alpha(c) do
    id lexer
  end
  def get_next_token(%{current_char: ":", next_char: "="} = lexer) do
    {Token.token(:assign, ":="), lexer |> advance() |> advance()}
  end
  def get_next_token(%{current_char: ";"} = lexer) do
    {Token.token(:semi, ";"), advance lexer}
  end
  def get_next_token(%{current_char: "."} = lexer) do
    {Token.token(:dot, "."), advance lexer}
  end
  def get_next_token(%{current_char: c} = lexer) do
    {c |> convert_char_to_atom() |> Token.token(c), advance lexer}
  end

  @spec lexer(String.t) :: t
  defp lexer(input) do
    input = String.trim input
    first_char = String.at input, 0
    next_char = String.at input, 1
    %__MODULE__{text: input, pos: 0, current_char: first_char, next_char: next_char}
  end

  @spec id(t, String.t) :: {Token.t, t}
  defp id(lexer, id_part \\ "")
  defp id(%{current_char: c} = lexer, id_part) when is_alphanum(c) do
    lexer
    |> advance()
    |> id(id_part <> c)
  end
  defp id(lexer, id_part) do
    case String.downcase id_part do
      "begin" -> {Token.token(:begin, "BEGIN"), lexer}
      "end" -> {Token.token(:end, "END"), lexer}
      _ -> {Token.token(:id, id_part), lexer}
    end
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
    %{lexer | pos: new_pos, current_char: lexer.next_char, next_char: String.at(text, new_pos + 1)}
  end
end
