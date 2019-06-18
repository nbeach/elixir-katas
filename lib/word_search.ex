defmodule WordSearch do
  import Enum

  def search(word, grid) do
    all_letter_locations = with_coordinates(grid)
    matching_sequences = find_matching_sequences(word, all_letter_locations)

    "#{word}: #{format_sequences(matching_sequences)}"
  end

  defp format_sequences(sequences) do
    sequences
    |> map(&format_sequence/1)
    |> join(" - ")
  end

  defp format_sequence(sequence) do
    map(sequence, fn {_, x, y} -> "(#{x},#{y})" end)
    |> join(", ")
  end

  defp find_matching_sequences(word, all_letter_locations) do
    location_to_letter_map = to_location_to_letter_map(all_letter_locations)

    all_letter_locations
    |> filter(&(is_first_letter_of?(&1, word)))
    |> flat_map(&(generate_potential_match_sequences_for_starting_location(&1, word)))
    |> filter(&(sequence_exists_in?(&1, location_to_letter_map)))
  end

  defp is_first_letter_of?({letter, _, _}, word) do
    letter === String.at(word, 0)
  end

  defp generate_potential_match_sequences_for_starting_location(first_letter_location, word) do
    directional_letter_offset_generators()
    |> map(fn offset_generator -> create_sequence(first_letter_location, word, offset_generator) end)
  end

  defp create_sequence(first_letter_location, word, offset_generator) do
    coordinate_offsets_for_letter = fn (letter, offset) ->
      {x_offset, y_offset} = offset_generator.(offset)
      {letter, x_offset, y_offset}
    end

    {_, initial_x, initial_y} = first_letter_location

    other_letter_locations = word
    |> String.graphemes()
    |> tl()
    |> with_index()
    |> map(fn {letter, index} -> {letter, index + 1} end)
    |> map(fn {letter, offset} -> coordinate_offsets_for_letter.(letter, offset) end)
    |> map(fn {letter, x_offset, y_offset} -> {letter, initial_x + x_offset, initial_y + y_offset} end)

    [first_letter_location] ++ other_letter_locations
  end

  defp directional_letter_offset_generators() do
   horizontal = fn offset -> {offset, 0} end
   vertical = fn offset -> {0, offset} end
   diagonal_downwards = fn offset -> {offset, offset} end
   diagonal_upwards = fn offset -> {offset, 0-offset} end
   generators = [horizontal, vertical, diagonal_downwards, diagonal_upwards]

   reverse_direction = fn generator -> &(generator.(0-&1)) end
   generators ++ map(generators, &(reverse_direction.(&1)))
  end

  defp sequence_exists_in?(sequence, location_to_letter_map) do
    all?(sequence, &(letter_exists_at_coordinates?(&1, location_to_letter_map)))
  end

  defp letter_exists_at_coordinates?({letter, x, y}, location_to_letter_map) do
    Map.get(location_to_letter_map, {x, y}) === letter
  end

  defp with_coordinates(grid) do
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
