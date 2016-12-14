defmodule InfixToPostfix do

  def convert infix do
    convert infix, '', ''
  end

  defp convert(infix, postfix, operators) when infix == '' do
    postfix ++ Enum.reverse(operators)
  end

  defp convert infix, postfix, operators do
    {symbol, infix} = dequeue infix

    {postfix, operators} = cond do
      is_operator symbol -> handle_operator symbol, operators, postfix
      '(' == symbol -> {postfix, operators ++ symbol}
      ')' == symbol -> handle_closing_parenthesis(operators, postfix)
      true -> {postfix ++ symbol, operators}
    end

    convert infix, postfix, operators
  end

  defp handle_operator symbol, operators, postfix do
    stack_top = peek operators
    if stack_top != '' and precedence(symbol) >= precedence(stack_top) do
      {operators, operator} = pop operators
      postfix = postfix ++ operator
    end

    {postfix, operators ++ symbol}
  end

  defp handle_closing_parenthesis operators, postfix do
    {postfix, operators}
  end
  
  defp is_operator symbol do
    precedence(symbol) != nil
  end

  defp precedence symbol do
    case symbol do
      '^' -> 1
      '*' -> 2
      '/' -> 2
      '+' -> 3
      '-' -> 3
      _ -> nil
    end
  end

  defp pop stack do
    Enum.split stack, Kernel.length(stack) - 1
  end

  defp peek stack do
    {stack, top} = Enum.split stack, Kernel.length(stack) - 1
    top
  end

  defp dequeue queue do
    Enum.split queue, 1
  end

end
