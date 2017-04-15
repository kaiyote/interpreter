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
      {%Interpreter.Token{type: :integer_const, value: 42}, %Interpreter.Lexer{current_char: nil, next_char: nil, pos: 2, text: "42"}}

      iex> lexer = %Interpreter.Lexer{text: "42 -24", pos: 2, current_char: " ", next_char: "-"}
      iex> Interpreter.Lexer.get_next_token lexer
      {%Interpreter.Token{type: :minus, value: nil}, %Interpreter.Lexer{current_char: "2", next_char: "4", pos: 4, text: "42 -24"}}

      iex> Interpreter.Lexer.get_next_token "4 - 2"
      {%Interpreter.Token{type: :integer_const, value: 4}, %Interpreter.Lexer{current_char: " ", next_char: "-", pos: 1, text: "4 - 2"}}

      iex> Interpreter.Lexer.get_next_token "3.14 - 1"
      {%Interpreter.Token{type: :real_const, value: 3.14}, %Interpreter.Lexer{current_char: " ", next_char: "-", pos: 4, text: "3.14 - 1"}}

      iex> Interpreter.Lexer.get_next_token "{this is a comment} 3.14 - 1"
      {%Interpreter.Token{type: :real_const, value: 3.14}, %Interpreter.Lexer{current_char: " ", next_char: "-", pos: 24, text: "{this is a comment} 3.14 - 1"}}
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
  def get_next_token(%{current_char: "{"} = lexer) do
    lexer
    |> skip_comment()
    |> get_next_token()
  end
  def get_next_token(%{current_char: c} = lexer) when is_digit(c) do
    number lexer
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
  defp id(lexer, "program"), do: {%Token{type: :program}, lexer}
  defp id(lexer, "var"), do: {%Token{type: :var}, lexer}
  defp id(lexer, "div"), do: {%Token{type: :integer_div}, lexer}
  defp id(lexer, "integer"), do: {%Token{type: :integer}, lexer}
  defp id(lexer, "real"), do: {%Token{type: :real}, lexer}
  defp id(lexer, "procedure"), do: {%Token{type: :procedure}, lexer}
  defp id(lexer, id_part), do: {%Token{type: :id, value: id_part}, lexer}

  @spec number(t, String.t) :: {Token.t, t}
  defp number(lexer, int_res \\ "")
  defp number(%{current_char: c} = lexer, int_res) when is_digit(c) do
    lexer
    |> advance()
    |> number(int_res <> c)
  end
  defp number(%{current_char: "."} = lexer, int_res) do
    unless String.contains? int_res, "." do
      lexer
      |> advance()
      |> number(int_res <> ".")
    end
  end
  defp number(lexer, int_res) do
    if String.contains? int_res, "." do
      real_val = String.to_float int_res
      {%Token{type: :real_const, value: real_val}, lexer}
    else
      int_val = String.to_integer int_res
      {%Token{type: :integer_const, value: int_val}, lexer}
    end
  end

  @spec convert_char_to_atom(String.t) :: Token.token_type
  defp convert_char_to_atom("+"), do: :plus
  defp convert_char_to_atom("-"), do: :minus
  defp convert_char_to_atom("*"), do: :mul
  defp convert_char_to_atom("/"), do: :float_div
  defp convert_char_to_atom("("), do: :lparen
  defp convert_char_to_atom(")"), do: :rparen
  defp convert_char_to_atom(";"), do: :semi
  defp convert_char_to_atom("."), do: :dot
  defp convert_char_to_atom(":"), do: :colon
  defp convert_char_to_atom(","), do: :comma

  @spec skip_whitespace(t) :: t
  defp skip_whitespace(%{current_char: c} = lexer) when is_whitespace(c) do
    lexer
    |> advance()
    |> skip_whitespace()
  end
  defp skip_whitespace(lexer), do: lexer

  @spec skip_comment(t) :: t
  defp skip_comment(%{current_char: c} = lexer) when c != "}" do
    lexer
    |> advance()
    |> skip_comment()
  end
  defp skip_comment(%{current_char: "}"} = lexer) do
    lexer
    |> advance()
  end

  @spec advance(t) :: t
  defp advance(%{text: text, pos: pos} = lexer) do
    new_pos = pos + 1
    %{lexer | pos: new_pos, current_char: lexer.next_char, next_char: String.at(text, new_pos + 1)}
  end
end
