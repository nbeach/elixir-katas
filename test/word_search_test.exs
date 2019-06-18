defmodule WordSearchTest do
  use ExUnit.Case

  test "finds words horizontally" do
    grid = [
      ["a", "b", "c"],
      ["o", "n", "e"],
      ["a", "b", "c"],
    ]
    result = WordSearch.search("one", grid)
#    IO.inspect(result)
    assert result == "one: (0,1), (1,1), (2,1)"
  end

end
