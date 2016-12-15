defmodule InfixToPostfixTest do
  use ExUnit.Case
  doctest InfixToPostfix

  test "convert() converts expressions with only addition" do
    assert InfixToPostfix.convert('a+b+c') == 'ab+c+'
  end

  test "convert() converts expressions with only subtraction" do
    assert InfixToPostfix.convert('a-b-c') == 'ab-c-'
  end

  test "convert() converts expressions with only multiplication" do
    assert InfixToPostfix.convert('a*b*c') == 'ab*c*'
  end

  test "convert() converts expressions with only division" do
    assert InfixToPostfix.convert('a/b/c') == 'ab/c/'
  end

  test "convert() converts expressions with only exponents" do
    assert InfixToPostfix.convert('a^b^c') == 'ab^c^'
  end

  test "convert() converts expressions with operators of mixed precedence" do
    assert InfixToPostfix.convert('a^b+c-d*e/f') == 'ab^c+de*f/-'
  end

  test "convert() converts expressions with parenthesis" do
    assert InfixToPostfix.convert('a*(b+c)') == 'abc+*'
  end

  test "convert() converts expressions with operators of mixed precedence and parenthesis" do
    assert InfixToPostfix.convert('a*(b+c*d^e)+f') == 'abcde^*+*f+'
  end
end
