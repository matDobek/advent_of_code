defmodule Puzzle do
  def solve(name) do
    name
    |> parse
    |> steps
  end

  defp steps(col), do: steps(col, 0)
  defp steps(col, n) do
    case col |> bright_enough? do
      true -> n
      _ ->
        col
        |> Enum.map(& &1 + 1)
        |> check_for_flashes()
        |> steps(n + 1)
    end
  end

  defp bright_enough?(col), do: col |> List.flatten |> Enum.all?(& &1 == 0)

  defp check_for_flashes(col), do: check_for_flashes(col, {0, 0})
  defp check_for_flashes(col, nil), do: col
  defp check_for_flashes(col, point) do
    cond do
      val_at(col, point) > 9 -> flash(col, point) |> check_for_flashes()
      true -> check_for_flashes(col, next(point))
    end
  end

  defp next({9, 9}), do: nil
  defp next({9, y}), do: {0, y+1}
  defp next({x, y}), do: {x+1, y}

  defp flash(col, point) do
    col = reset_at(col, point)

    neighbors_of(point)
    |> Enum.reject(& val_at(col, &1) == 0)
    |> Enum.reduce(col, &inc_at(&2, &1))
  end

  defp neighbors_of({x, y}) do
    xs = [x - 1, x, x + 1]
    ys = [y - 1, y, y + 1]

    (for x <- xs, y <- ys, do: {x, y})
    |> Enum.filter(fn {nx, ny} -> nx in 0..9 and ny in 0..9 end)
    |> Enum.reject(fn {nx, ny} -> {x, y} == {nx, ny} end)
  end

  defp position({x, y}), do: x + y*10
  defp val_at(col, point), do: Enum.at(col, position(point))
  defp inc_at(col, point), do: List.replace_at(col, position(point), val_at(col, point) + 1)
  defp reset_at(col, point), do: List.replace_at(col, position(point), 0)

  defp parse(name) do
    name
    |> File.read
    |> Kernel.elem(1)
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn str ->
      str
      |> String.trim
      |> String.graphemes
    end)
    |> List.flatten
    |> Enum.map(&String.to_integer/1)
  end
end

"11.input"
|> Puzzle.solve
|> IO.inspect
