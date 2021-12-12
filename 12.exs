defmodule Puzzle do
  def solve(name) do
    col = name |> parse
    rev_col = col |> Enum.map(fn {a,b} -> {b,a} end)

    (col ++ rev_col)
    |> find("start", [])
    |> List.flatten
    |> Enum.count
  end

  defp find(_, "end", traversed_path), do: { ["end" | traversed_path] |> Enum.reverse }
  defp find(col, start, traversed_path) do
    available_paths = col
                      |> Enum.filter(fn {a, _} ->
                        a == start && can_visit_cave?(a, traversed_path)
                      end)

    case available_paths do
      [] -> []
      _ -> Enum.map(available_paths, fn {_, b} -> find(col, b, [start | traversed_path]) end)
    end
  end

  defp can_visit_cave?("start", traversed_path), do: "start" not in traversed_path
  defp can_visit_cave?("end", traversed_path), do: "end" not in traversed_path
  defp can_visit_cave?(cave, traversed_path) do
    large_cave = String.upcase(cave) == cave

    small_caves = Enum.filter([cave | traversed_path], & String.downcase(&1) == &1)
    sc_len = small_caves |> length()
    sc_uniq_len = small_caves |> Enum.uniq |> length

    large_cave || sc_len in sc_uniq_len..sc_uniq_len+1
  end

  defp parse(name) do
    name
    |> File.read
    |> Kernel.elem(1)
    |> String.trim
    |> String.split("\n")
    |> Enum.map(& String.split(&1, "-") |> List.to_tuple)
  end
end

"12.input"
|> Puzzle.solve
|> IO.inspect
