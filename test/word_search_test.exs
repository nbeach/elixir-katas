defmodule WordSearchTest do
  use ExUnit.Case

  test "finds words forwards horizontally" do
    grid = [
      ["a", "b", "c"],
      ["o", "n", "e"],
      ["a", "b", "c"],
    ]

    assert WordSearch.search("one", grid) == "one: (0,1), (1,1), (2,1)"
  end

  test "finds words in reverse horizontally" do
    grid = [
      ["a", "b", "c"],
      ["e", "n", "o"],
      ["a", "b", "c"],
    ]

    assert WordSearch.search("one", grid) == "one: (2,1), (1,1), (0,1)"
  end

  test "finds words forward vertically" do
    grid = [
      ["a", "o", "c"],
      ["a", "n", "c"],
      ["a", "e", "c"],
    ]

    assert WordSearch.search("one", grid) == "one: (1,0), (1,1), (1,2)"
  end

  test "finds words in reverse vertically" do
    grid = [
      ["a", "e", "c"],
      ["a", "n", "c"],
      ["a", "o", "c"],
    ]

    assert WordSearch.search("one", grid) == "one: (1,2), (1,1), (1,0)"
  end

  test "finds words diagonally downwards" do
    grid = [
      ["o", "b", "c"],
      ["a", "n", "c"],
      ["a", "b", "e"],
    ]

    assert WordSearch.search("one", grid) == "one: (0,0), (1,1), (2,2)"
  end

  test "finds words in reverse diagonally downwards" do
    grid = [
      ["e", "b", "c"],
      ["a", "n", "c"],
      ["a", "b", "o"],
    ]

    assert WordSearch.search("one", grid) == "one: (2,2), (1,1), (0,0)"
  end

  test "finds words in reversed diagonally upwards" do
    grid = [
      ["a", "b", "o"],
      ["a", "n", "c"],
      ["e", "b", "c"],
    ]

    assert WordSearch.search("one", grid) == "one: (2,0), (1,1), (0,2)"
  end

  test "finds words diagonally upwards" do
    grid = [
      ["a", "b", "e"],
      ["a", "n", "c"],
      ["o", "b", "c"],
    ]

    assert WordSearch.search("one", grid) == "one: (0,2), (1,1), (2,0)"
  end

end
