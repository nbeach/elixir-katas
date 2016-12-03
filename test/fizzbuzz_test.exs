defmodule FizzBuzzTest do
  use ExUnit.Case
  import FizzBuzz
  doctest FizzBuzz

  test "stuff" do
    assert evaluate (1) == 1
  end

end
