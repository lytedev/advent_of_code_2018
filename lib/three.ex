defmodule Three do
  @dimension_parser ~r/\#\d+\s@\s(\d+),(\d+):\s(\d+)x(\d+)/

  def part1(input_stream) do
    input_stream
    |> Stream.map(&parse_dimensions/1)
    |> Enum.to_list()
  end

  def parse_dimensions(str) do
    l = Regex.run(@dimension_parser, str)
    [x, y, w, h] = l |> tl() |> Enum.map(&String.to_integer/1)
    {x, y, w, h}
  end

  def play_battleship(pos, {hit_once, flagged}) do
    # MapSet.put(hit_
  end

  def part2(input_stream) do
    input_stream
    nil
  end
end
