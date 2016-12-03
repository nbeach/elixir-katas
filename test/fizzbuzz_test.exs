defmodule FizzBuzzTest do
  use ExUnit.Case
  doctest FizzBuzz

  test "evauluate when a number is given returns the number" do
    assert FizzBuzz.evaluate(1) == "1"
    assert FizzBuzz.evaluate(2) == "2"
    assert FizzBuzz.evaluate(4) == "4"
  end

  test "evaluate when a multiple of 3 is given returns fizz" do
    assert FizzBuzz.evaluate(3) == "fizz"
    assert FizzBuzz.evaluate(6) == "fizz"
    assert FizzBuzz.evaluate(9) == "fizz"
  end

end
