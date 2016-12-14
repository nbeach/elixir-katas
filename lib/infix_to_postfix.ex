defmodule InfixToPostfix do

  def convert infix do
    convert infix, '', ''
  end

  defp convert(infix, postfix, operators) when infix == '' do
    postfix ++ Enum.reverse(operators)
  end

  defp convert infix, postfix, operators do
    {symbol, infix} = dequeue infix

    {postfix, operators} = if is_operator symbol do
      stack_top = peek operators
      if stack_top != '' and precedence(symbol) >= precedence(stack_top) do
        {operators, operator} = pop operators
        postfix = postfix ++ operator
      end

      {postfix, operators ++ symbol}
    else
      postfix = postfix ++ symbol
      {postfix, operators}
    end

    convert infix, postfix, operators
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
