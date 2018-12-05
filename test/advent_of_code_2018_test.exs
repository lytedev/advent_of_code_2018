defmodule AdventOfCode2018Test do
  use ExUnit.Case, async: true

  @doc "https://adventofcode.com/2018/day/1"
  test "Day 1" do
    input_stream =
      File.stream!("./inputs/one.txt", [:read])
      |> Stream.map(&String.trim_trailing/1)
      |> Stream.map(&String.to_integer/1)

    assert One.part1(input_stream) == 416
    assert One.part2(input_stream) == 56752
  end

  @doc "https://adventofcode.com/2018/day/2"
  test "Day 2" do
    input_stream = File.stream!("./inputs/two.txt", [:read])

    assert Two.part1(input_stream) == 6696
    assert Two.part2(input_stream) == "bvnfawcnyoeyudzrpgslimtkj"
  end

  @tag :current_day
  @doc "https://adventofcode.com/2018/day/3"
  test "Day 3" do
    # input_stream = File.stream!("./inputs/three.txt", [:read])
    assert Three.part1(nil) == nil
    assert Three.part2(nil) == nil
  end
end
