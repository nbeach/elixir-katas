defmodule WordSearch do
  import Enum

  def search(word, grid) do
    all_letter_locations = with_indexes(grid)
    matching_sequences = find_matching_sequences(word, all_letter_locations)

    "#{word}: #{format_sequences(matching_sequences)}"
  end

  defp format_sequences(sequences) do
    formatted_sequences = sequences
      |> map(&format_sequence/1)
      |> join(" - ")
  end

  defp format_sequence(sequence) do
    map(sequence, fn {_, x, y} -> "(#{x},#{y})" end)
      |> join(", ")
  end

  defp find_matching_sequences(word, all_letter_locations) do
    [first_letter | other_letters] = String.graphemes(word)
    location_to_letter_map = to_location_to_letter_map(all_letter_locations)

    filter(all_letter_locations, fn {letter, _, _} -> letter === first_letter end)
      |> map(&(generate_potential_match_sequences(&1, other_letters)))
      |> filter(&(sequence_exists_in?(&1, location_to_letter_map)))
  end

  defp generate_potential_match_sequences({letter, x, y}, other_letters) do
    other_letter_locations = with_index(other_letters) |> map(fn {letter, index} -> {letter, x + index + 1, y } end)
    [{letter, x, y}] ++ other_letter_locations
  end

  defp sequence_exists_in?(sequence, location_to_letter_map) do
    all?(sequence, &(letter_exists_at_coordinates?(&1, location_to_letter_map)))
  end

  defp letter_exists_at_coordinates?({letter, x, y}, location_to_letter_map) do
    Map.get(location_to_letter_map, {x, y}) !== nil
  end

  defp with_indexes(grid) do
    grid
    |> map(&with_index/1)
    |> with_index()
    |> flat_map(&flatten_index_tuples/1)
  end

  defp to_location_to_letter_map(letter_locations) do
    reduce(letter_locations, %{}, fn {letter, x, y}, map -> Map.put(map, {x, y}, letter) end)
  end

  defp flatten_index_tuples({values_and_x_coordinates, y}) do
    map(values_and_x_coordinates, fn {letter, x} -> {letter, x, y} end)
  end

end
