defmodule Two do
  def input_stream() do
    File.stream!("./inputs/two.txt", [:read])
    |> Stream.map(&String.trim/1)
  end

  def bool_int(true), do: 1
  def bool_int(false), do: 0

  @doc """
  I'm sure this can be greatly simplified and more DRY.
  https://adventofcode.com/2018/day/2
      iex> Two.part1(Two.input_stream())
      6696
  """
  def part1(id_list) do
    id_list
    |> Stream.map(fn s ->
      s
      |> String.codepoints()
      |> Enum.reduce(%{}, fn l, acc -> Map.update(acc, l, 1, &(&1 + 1)) end)
      |> Map.values()
      |> MapSet.new()
    end)
    |> Enum.to_list()
    |> Enum.reduce({0, 0}, fn s, {twos, threes} ->
      {twos + bool_int(2 in s), threes + bool_int(3 in s)}
    end)
    |> (fn {twos, threes} -> twos * threes end).()
  end

  @doc """
  https://adventofcode.com/2018/day/2#part2
      iex> Two.part2(Two.input_stream())
      "bvnfawcnyoeyudzrpgslimtkj"
  """
  def part2(id_list) do
    id_list
    |> Enum.to_list()
    |> jaro_compare_permute_all()
    |> List.flatten()
    |> Enum.reduce({"", "", 0}, fn {id1, id2, jd}, {aid1, aid2, ajd} ->
      if jd > ajd do
        {id1, id2, jd}
      else
        {aid1, aid2, ajd}
      end
    end)
    |> (fn {id1, id2, _jd} ->
          [eq: p1, del: _, ins: _, eq: p2] = String.myers_difference(id1, id2)
          p1 <> p2
        end).()
  end

  @doc """
  Calculates the jaro_distance between the given string and each string in the
  list, returning a tuple with the compared string and the jaro distance.
  """
  @spec jaro_compare(binary, [binary]) :: [{binary, float}]
  def jaro_compare(s, []), do: []

  def jaro_compare(s, [h | t]) do
    [{h, String.jaro_distance(s, h)} | jaro_compare(s, t)]
  end

  @doc """
  Recursively calculates the jaro distance between every permutation of two
  items in the list.
  """
  @spec jaro_compare_permute_all([binary]) :: [{binary, binary, float}]
  def jaro_compare_permute_all([]), do: []
  def jaro_compare_permute_all([h | []]), do: []

  def jaro_compare_permute_all([h | t]) do
    [jaro_compare(h, t) |> Enum.map(fn {c, jd} -> {h, c, jd} end) | jaro_compare_permute_all(t)]
  end
end
