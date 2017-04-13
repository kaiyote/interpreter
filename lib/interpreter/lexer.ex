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
      iex> Interpreter.Lexer.get_next_token lexer
      {%Interpreter.Token{type: :plus, value: nil}, %Interpreter.Lexer{current_char: nil, next_char: nil, pos: 6, text: "1    +"}}

      iex> lexer = %Interpreter.Lexer{text: "42", pos: 0, current_char: "4", next_char: "2"}
      iex> Interpreter.Lexer.get_next_token lexer
      {%Interpreter.Token{type: :integer, value: 42}, %Interpreter.Lexer{current_char: nil, next_char: nil, pos: 2, text: "42"}}

      iex> lexer = %Interpreter.Lexer{text: "42 -24", pos: 2, current_char: " ", next_char: "-"}
      iex> Interpreter.Lexer.get_next_token lexer
      {%Interpreter.Token{type: :minus, value: nil}, %Interpreter.Lexer{current_char: "2", next_char: "4", pos: 4, text: "42 -24"}}

      iex> Interpreter.Lexer.get_next_token "4 - 2"
      {%Interpreter.Token{type: :integer, value: 4}, %Interpreter.Lexer{current_char: " ", next_char: "-", pos: 1, text: "4 - 2"}}
  """
  @spec get_next_token(t | String.t) :: {Token.t, t}
  def get_next_token(input) when is_binary(input) do
    input
    |> String.downcase()
    |> lexer
    |> get_next_token()
  end
  def get_next_token(%{current_char: nil} = lexer) do
    {%Token{type: :eof}, lexer}
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
    {%Token{type: :assign}, lexer |> advance() |> advance()}
  end
  def get_next_token(%{current_char: c} = lexer) do
    {%Token{type: convert_char_to_atom(c)}, advance lexer}
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
  defp id(lexer, "begin"), do: {%Token{type: :begin}, lexer}
  defp id(lexer, "end"), do: {%Token{type: :end}, lexer}
  defp id(lexer, id_part), do: {%Token{type: :id, value: id_part}, lexer}

  @spec integer(t, String.t) :: {Token.t, t}
  defp integer(lexer, int_res \\ "")
  defp integer(%{current_char: c} = lexer, int_res) when is_digit(c) do
    lexer
    |> advance()
    |> integer(int_res <> c)
  end
  defp integer(lexer, int_res) do
    int_val = String.to_integer int_res
    {%Token{type: :integer, value: int_val}, lexer}
  end

  @spec convert_char_to_atom(String.t) :: Token.token_type
  defp convert_char_to_atom("+"), do: :plus
  defp convert_char_to_atom("-"), do: :minus
  defp convert_char_to_atom("*"), do: :mul
  defp convert_char_to_atom("/"), do: :div
  defp convert_char_to_atom("("), do: :lparen
  defp convert_char_to_atom(")"), do: :rparen
  defp convert_char_to_atom(";"), do: :semi
  defp convert_char_to_atom("."), do: :dot

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
