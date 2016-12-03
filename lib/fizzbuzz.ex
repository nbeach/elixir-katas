defmodule FizzBuzz do

  def evaluate(value) do
    if 0 == rem(value, 3) do
      "fizz"
    else
      Integer.to_string value
    end
  end

end
