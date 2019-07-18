defmodule InfixToPostfixTest do
  use ExUnit.Case
  doctest InfixToPostfix

  describe "converts an infix expression to postfix when it contains" do
    test "addition", do: assert(InfixToPostfix.convert("a + b + c") == "ab+c+")
    test "subtraction", do: assert(InfixToPostfix.convert("a - b - c") == "ab-c-")
    test "multiplication", do: assert(InfixToPostfix.convert("a * b * c") == "ab*c*")
    test "division", do: assert(InfixToPostfix.convert("a / b / c") == "ab/c/")
    test "exponents", do: assert(InfixToPostfix.convert("a ^ b ^ c") == "ab^c^")
    test "parenthesis", do: assert(InfixToPostfix.convert(" a * ( b + c )") == "abc+*")

    test "operators of mixed precedence",
      do: assert(InfixToPostfix.convert("a ^ b + c - d * e / f") == "ab^c+de*f/-")

    test "operators of mixed precedence and parenthesis",
      do: assert(InfixToPostfix.convert("a * ( b + c * d ^ e ) + f") == "abcde^*+*f+")
  end
end
