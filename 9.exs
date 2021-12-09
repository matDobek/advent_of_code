defmodule Puzzle do
  def solve(name) do
    col   = name |> parse
    x_max = col |> Enum.at(0) |> length |> Kernel.-(1)
    y_max = col |> length |> Kernel.-(1)
    boundries = {x_max, y_max}

    col
    |> lowpoints(boundries)
    |> Enum.map(& basin(col, [], &1, boundries) |> length)
    |> Enum.sort
    |> Enum.take(-3)
    |> Enum.reduce(& &1 * &2)
  end

  defp value_for(col, {x, y}), do: col |> Enum.at(y) |> Enum.at(x)

  defp neighbors_for({x = 0, y = 0}, _), do: [{x+1, y}, {x, y+1}]
  defp neighbors_for({x = 0, y}, {_, y}), do: [{x+1, y}, {x, y-1}]
  defp neighbors_for({x, y = 0}, {x, _}), do: [{x-1, y}, {x, y+1}]
  defp neighbors_for({x, y}, {x, y}), do: [{x-1, y}, {x, y-1}]
  defp neighbors_for({x = 0, y}, _), do: [{x+1, y}, {x, y-1}, {x, y+1}]
  defp neighbors_for({x, y = 0}, _), do: [{x-1, y}, {x+1, y}, {x, y+1}]
  defp neighbors_for({x, y}, {x, _}), do: [{x-1, y}, {x, y-1}, {x, y+1}]
  defp neighbors_for({x, y}, {_, y}), do: [{x-1, y}, {x+1, y}, {x, y-1}]
  defp neighbors_for({x, y}, _), do: [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}]

  defp basin(col, traversed, point, boundries) do
    cond do
      value_for(col, point) == 9 -> traversed
      point in traversed -> traversed
      true ->
        neighbors_for(point, boundries)
        |> Enum.reduce([point | traversed], fn neighbor, trav ->
          basin(col, trav, neighbor, boundries)
        end)
    end
  end

  defp lowpoints(col, boundries) do
    lowpoints(col, {0, 0}, boundries) |> Enum.reject(&is_nil/1)
  end

  defp lowpoints(col, {x, y}, {x_max, y_max}) do
    risk_level = case lowpoint?(col, {x, y}, {x_max, y_max}) do
      true -> {x, y}
      _ -> nil
    end

    [risk_level | cond do
      x >= x_max and y >= y_max -> []
      x >= x_max -> lowpoints(col, {0, y+1}, {x_max, y_max})
      true -> lowpoints(col, {x+1, y}, {x_max, y_max})
    end]
  end

  defp lowpoint?(col, point, boundries) do
    neighbors_for(point, boundries)
    |> Enum.map(fn neighbor -> value_for(col, point) < value_for(col, neighbor) end)
    |> Enum.all?
  end

  defp parse(name) do
    name
    |> File.read
    |> Kernel.elem(1)
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.graphemes |> Enum.map(&String.to_integer/1) end)
  end
end

"9.input"
|> Puzzle.solve
|> IO.inspect
