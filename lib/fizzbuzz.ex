defmodule FizzBuzz do
  def evaluate(value) do
    case {rem(value, 3), rem(value, 5)} do
      {0, 0} -> "fizzbuzz"
      {0, _} -> "fizz"
      {_, 0} -> "buzz"
      _ -> Integer.to_string(value)
    end
  end
end
