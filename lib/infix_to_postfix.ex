defmodule InfixToPostfix do
  def convert(infix) do
    convert(String.split(infix, " "), "", [])
  end

  defp convert(infix, postfix, operators) when infix == [] do
    postfix <> Enum.reduce(operators, fn x, acc -> acc <> x end)
  end

  defp convert(infix, postfix, operators) do
    [symbol | infix] = infix

    {postfix, operators} =
      cond do
        is_operator(symbol) -> handle_operator(symbol, operators, postfix)
        "(" == symbol -> handle_opening_parenthesis(symbol, operators, postfix)
        ")" == symbol -> handle_closing_parenthesis(operators, postfix)
        true -> {postfix <> symbol, operators}
      end

    convert(infix, postfix, operators)
  end

  defp handle_operator(symbol, operators, postfix) do
    top_operator = List.first(operators)

    if(precedence(symbol) >= precedence(top_operator)) do
      [_ | operators] = operators
      {postfix <> top_operator, [symbol] ++ operators}
    else
      {postfix, [symbol] ++ operators}
    end
  end

  defp handle_opening_parenthesis(symbol, operators, postfix) do
    {postfix, [symbol] ++ operators}
  end

  defp handle_closing_parenthesis(operators, postfix) do
    [operator | operators] = operators

    if(operator != "(") do
      handle_closing_parenthesis(operators, postfix <> operator)
    else
      {postfix, operators}
    end
  end

  defp is_operator(symbol) do
    precedence(symbol) != nil
  end

  defp precedence(symbol) do
    %{
      "^" => 1,
      "*" => 2,
      "/" => 2,
      "+" => 3,
      "-" => 3
    }[symbol]
  end
end
