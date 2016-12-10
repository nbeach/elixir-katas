defmodule InfixToPostfixTest do
  use ExUnit.Case
  doctest InfixToPostfix

  test "convert() converts expressions with only addition" do
    assert InfixToPostfix.convert('a+b+c') == 'ab+c+'
  end

  test "convert() converts expressions with only subtraction)" do
    assert InfixToPostfix.convert('a-b-c') == 'ab-c-'
  end
end
