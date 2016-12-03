defmodule FizzBuzz do

  def evaluate(value) do
    cond do
        rem(value, 3) == 0 -> "fizz"
        rem(value, 5) == 0 -> "buzz"
        true -> Integer.to_string value
    end
  end

end
