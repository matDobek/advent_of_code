defmodule Puzzle do
  def solve(name) do
    r = name
        |> Enum.map(&String.graphemes/1)
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&count(&1, {0,0}))

    a = r
      |> Enum.map(&max/1)
      |> Enum.join()
      |> String.to_integer(2)

    b = r
      |> Enum.map(&min/1)
      |> Enum.join()
      |> String.to_integer(2)

    a*b
  end

  defp count(["0" | tail], {a, b}), do: count(tail, {a + 1, b})
  defp count(["1" | tail], {a, b}), do: count(tail, {a, b + 1})
  defp count(_, r), do: r

  defp max({a, b}) when a > b, do: "0"
  defp max(_), do: "1"

  defp min({a, b}) when a <= b, do: "0"
  defp min(_), do: "1"

  def solve2(collection) do
    a = collection
        |> do_solve2(0, "")
        |> String.to_integer(2)
  end

  defp do_solve2([e], _, _), do: e
  defp do_solve2(collection, i, prefix) do
    r = collection
        |> Enum.map(&String.at(&1, i))
        |> count({0,0})
        |> max()

    new_prefix = prefix <> r

    collection
    |> Enum.filter(fn str ->
      str |> String.starts_with?(new_prefix)
    end)
    |> do_solve2(i + 1, new_prefix)
  end
end

"3.input"
|> Helpers.read_input
|> Puzzle.solve2
|> IO.puts()

# 4160394
# 4125600
