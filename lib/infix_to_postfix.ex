defmodule InfixToPostfix do

  def convert infix do
    convert String.split(infix, " "), "", []
  end

  defp convert(infix, postfix, operators) when infix == [] do
    postfix <> Enum.reduce(operators, fn(x, acc) -> acc <> x end)
  end

  defp convert infix, postfix, operators do
    {symbol, infix} = dequeue infix

    {postfix, operators} = cond do
      is_operator symbol -> handle_operator symbol, operators, postfix
      "(" == symbol -> {postfix, [symbol] ++ operators}
      ")" == symbol -> handle_closing_parenthesis(operators, postfix)
      true -> {postfix <> symbol, operators}
    end

    convert infix, postfix, operators
  end

  defp handle_operator symbol, operators, postfix do
    if operators != [] do
      stack_top = peek operators
      if stack_top != "" and precedence(symbol) >= precedence(stack_top) do
        {operator, operators} = pop operators
        postfix = postfix <> operator
      end
    end

    {postfix, [symbol] ++ operators}
  end

  defp handle_closing_parenthesis operators, postfix do
    {operator, operators} = pop operators
    if operator != "(" do
      handle_closing_parenthesis operators, postfix <> operator
    else
      {postfix, operators}
    end

  end

  defp is_operator symbol do
    precedence(symbol) != nil
  end

  defp precedence symbol do
    case symbol do
      "^" -> 1
      "*" -> 2
      "/" -> 2
      "+" -> 3
      "-" -> 3
      _ -> nil
    end
  end

  defp pop stack do
    [top | stack ] = stack
    {top, stack}
  end

  defp peek stack do
    [top | _ ] = stack
    top
  end

  defp dequeue queue do
    [symbol | infix] = queue
    {symbol, infix}
  end

end
