defmodule Puzzle do
  def solve(name) do
    name
    |> parse
    |> Enum.reduce(%{}, fn pair_of_points, acc ->
      pair_of_points
      |> all_points_in_between
      |> Enum.reduce(acc, fn {x, y}, acc ->
        acc
        |> Map.update({x, y}, 1, & &1 + 1)
      end)
    end)
    |> Enum.count(fn {_k, v} -> v > 1 end)
  end

  defp all_points_in_between([{x, y1}, {x, y2}]) do
    y1..y2
    |> Enum.map(fn y -> {x, y} end)
  end

  defp all_points_in_between([{x1, y}, {x2, y}]) do
    x1..x2
    |> Enum.map(fn x -> {x, y} end)
  end

  defp all_points_in_between([{x1, y1}, {x2, y2}]) do
    [x1..x2, y1..y2]
    |> Enum.map(&Enum.to_list/1)
    |> Enum.zip
  end

  defp parse(name) do
    name
    |> File.read()
    |> Kernel.elem(1)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(" -> ")
      |> Enum.map(fn coords ->
        coords
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple
      end)
    end)
  end
end

"5.input"
|> Puzzle.solve()
|> IO.inspect()
