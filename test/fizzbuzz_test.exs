defmodule FizzBuzzTest do
  use ExUnit.Case
  doctest FizzBuzz

  test "evauluate when a number is given returns the number" do
    assert FizzBuzz.evaluate(1) == "1"
    assert FizzBuzz.evaluate(4) == "4"
  end

  test "evaluate when a multiple of 3 is given returns fizz" do
    assert FizzBuzz.evaluate(3) == "fizz"
    assert FizzBuzz.evaluate(9) == "fizz"
  end

  test "evaluate when a multiple of 5 is given returns buzz" do
    assert FizzBuzz.evaluate(10) == "buzz"
    assert FizzBuzz.evaluate(25) == "buzz"
  end

  test "evaluate when a multiple of 3 and 5 is given returns fizzbuzz" do
    assert FizzBuzz.evaluate(15) == "fizzbuzz"
    assert FizzBuzz.evaluate(30) == "fizzbuzz"
  end

end
