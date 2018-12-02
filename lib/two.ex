defmodule Two do
  def input_stream() do
    File.stream!("./inputs/two.txt", [:read])
    |> Stream.map(&String.trim/1)
  end

  @doc """
  I'm sure this can be greatly simplified and more DRY.
  https://adventofcode.com/2018/day/2
      iex> Two.part1(Two.input_stream())
      6696
  """
  def part1(id_list) do
    id_list
    |> Enum.to_list()
    |> Enum.map(&id_checker/1)
    |> Enum.reduce(%{two: 0, three: 0}, fn %{has_two: two, has_three: three}, acc ->
      acc
      |> Map.put(
        :two,
        if two do
          acc.two + 1
        else
          acc.two
        end
      )
      |> Map.put(
        :three,
        if three do
          acc.three + 1
        else
          acc.three
        end
      )
    end)
    |> (fn t -> t.three * t.two end).()
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

  def id_checker(s) do
    s
    |> String.codepoints()
    |> Enum.reduce(%{}, fn l, acc ->
      Map.update(acc, l, 1, &(&1 + 1))
    end)
    |> Enum.reduce(%{has_two: false, has_three: false}, fn {k, v}, acc ->
      case v do
        2 -> %{acc | has_two: true}
        3 -> %{acc | has_three: true}
        _ -> acc
      end
    end)
  end
end
