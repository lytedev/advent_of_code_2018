defmodule One do
  def input_stream() do
    File.stream!("./inputs/one.txt", [:read])
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_integer/1)
  end

  @doc """
  https://adventofcode.com/2018/day/1
      iex> One.part1(One.input_stream())
      416
  """
  def part1(list, initial_freq \\ 0), do: initial_freq + Enum.sum(list)

  @doc """
  https://adventofcode.com/2018/day/1#part2
      iex> One.part2(One.input_stream())
      56752
  """
  def part2(list, initial_freq \\ 0) do
    list
    |> Stream.cycle()
    |> Enum.reduce_while({initial_freq, %{initial_freq => true}}, &until_member/2)
  end

  defp until_member(i, {last, acc}) do
    new_last = i + last

    case Map.has_key?(acc, new_last) do
      true -> {:halt, new_last}
      _ -> {:cont, {new_last, Map.put(acc, new_last, true)}}
    end
  end
end
