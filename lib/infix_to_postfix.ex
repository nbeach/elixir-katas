defmodule InfixToPostfix do

  def convert infix do
    convert String.split(infix, " "), "", []
  end

  defp convert(infix, postfix, operators) when infix == [] do
    postfix <> Enum.reduce(operators, fn(x, acc) -> acc <> x end)
  end

  defp convert infix, postfix, operators do
    [symbol | infix] = infix

    {postfix, operators} = cond do
      is_operator symbol -> handle_operator symbol, operators, postfix
      "(" == symbol -> {postfix, [symbol] ++ operators}
      ")" == symbol -> handle_closing_parenthesis(operators, postfix)
      true -> {postfix <> symbol, operators}
    end

    convert infix, postfix, operators
  end

  defp pop stack do
    stack_top = if(stack != []) do
      [stack_top | _ ] = stack
      stack_top
    else
      nil
    end

    {stack_top, stack}
  end

  defp handle_operator symbol, operators, postfix do
    {stack_top, operators} = pop operators

    {operators, postfix} = if(stack_top != nil) do
      [stack_top | _ ] = operators
      cond do
        precedence(symbol) >= precedence(stack_top) -> move_stack_top operators, postfix
        true -> {operators, postfix}
      end
    else
       {operators, postfix}
    end

    {postfix, [symbol] ++ operators}
  end

  defp move_stack_top stack, destination do
      [top | stack ] = stack
      destination = destination <> top
      {stack, destination}
  end

  defp handle_closing_parenthesis operators, postfix do
    [operator | operators ] = operators
    cond do
       operator != "(" -> handle_closing_parenthesis operators, postfix <> operator
       true -> {postfix, operators}
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

end
