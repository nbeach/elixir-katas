defmodule FizzBuzzTest do
  use ExUnit.Case
  doctest FizzBuzz

  test "When a number is given returns the number" do
    assert FizzBuzz.evaluate(1) == "1"
    assert FizzBuzz.evaluate(2) == "2"
    assert FizzBuzz.evaluate(4) == "4"
  end

end
