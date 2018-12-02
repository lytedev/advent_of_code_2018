defmodule One do
  def input() do
    File.read!("./inputs/one.txt")
    |> String.split("\n", trim: true)
  end

  @doc """
  https://adventofcode.com/2018/day/1
      iex> One.part1(One.input())
      416
  """
  def part1(list) do
    list
    |> Enum.map(&parse_integer/1)
    |> Enum.sum()
  end

  @doc """
  This solution seems to run much slower than I would like.
  https://adventofcode.com/2018/day/1#part2
      iex> One.part2(One.input())
      56752
  """
  def part2(list) do
    list
    |> Enum.map(&parse_integer/1)
    |> Stream.cycle()
    |> Stream.transform([0], fn i, [x | t] ->
      if Enum.member?(t, x) do
        {:halt, [x | t]}
      else
        {[i + x], [i + x | [x | t]]}
      end
    end)
    |> Enum.to_list()
    |> Enum.reverse()
    |> List.first()
  end

  def parse_integer(s) do
    s
    |> String.trim_leading("+")
    |> Integer.parse()
    |> elem(0)
  end
end
