defmodule FizzBuzzTest do
  use ExUnit.Case
  doctest FizzBuzz

  describe "when given a" do

     test "number returns the number" do
        assert FizzBuzz.evaluate(1) == "1"
        assert FizzBuzz.evaluate(4) == "4"
      end

      test "multiple of 3 returns fizz" do
        assert FizzBuzz.evaluate(3) == "fizz"
        assert FizzBuzz.evaluate(9) == "fizz"
      end

      test "multiple of 5 returns buzz" do
        assert FizzBuzz.evaluate(10) == "buzz"
        assert FizzBuzz.evaluate(25) == "buzz"
      end

      test "multiple of 3 and 5 returns fizzbuzz" do
        assert FizzBuzz.evaluate(15) == "fizzbuzz"
        assert FizzBuzz.evaluate(30) == "fizzbuzz"
      end

  end

end
