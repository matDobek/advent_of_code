defmodule Puzzle do
  def solve(name) do
    col = name
          |> parse
          |> Enum.sort

    min = col |> Enum.min
    max = col |> Enum.max

    crabs = col
            |> Enum.reduce(%{}, fn e, acc ->
              acc
              |> Map.update(e, 1, fn x -> x + 1 end)
            end)
            |> Enum.to_list

    min..max
    |> Enum.to_list
    |> calc(crabs)
    |> Enum.min_by(fn {_pos, fuel} -> fuel end)
  end

  defp calc([], _), do: []
  defp calc([e | tail], crabs), do: [{e, cost(crabs, e)} | calc(tail, crabs)]

  defp cost([], _), do: 0
  defp cost([{pos, number} | tail], e) do
    offset = (e - pos) |> abs

    fuel_cost_per_unit(offset, 0) * number + cost(tail, e)
  end

  defp fuel_cost_per_unit(0, cost), do: cost
  defp fuel_cost_per_unit(x, cost), do: cost + fuel_cost_per_unit(x-1, cost+1)

  defp parse(name) do
    name
    |> File.read
    |> Kernel.elem(1)
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

"7.input"
|> Puzzle.solve
|> IO.inspect
