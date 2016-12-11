defmodule InfixToPostfix do

  def convert infix do
    convert infix, '', ''
  end

  defp convert(infix, postfix, operators) when infix == '' do
    postfix ++ operators
  end

  defp convert infix, postfix, operators do
    {symbol, infix} = dequeue infix

    {postfix, operators} = if is_operator symbol do
      {operators, stack_top} = pop operators
      {postfix ++ stack_top, operators ++ symbol}
    else
      postfix = postfix ++ symbol
      {postfix, operators}
    end

    convert infix, postfix, operators
  end

  defp is_operator symbol do
    symbol == '+' or
    symbol == '-' or
    symbol == '*' or
    symbol == '/' or
    symbol == '^'
  end

  defp pop stack do
    Enum.split stack, Kernel.length(stack) - 1
  end

  defp dequeue queue do
    Enum.split queue, 1
  end

end
