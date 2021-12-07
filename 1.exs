defmodule Puzzle do
  def solve(name) do
    name
    |> Helpers.read_input()
    |> Enum.map(&String.to_integer/1)
    |> flatten()
    |> cmp()
    |> Enum.filter(& &1)
    |> Kernel.length()
  end

  defp flatten([a, b, c | tail]), do: [(a+b+c) | flatten([b, c | tail])]

  defp flatten(_), do: []

  defp cmp([a, b | tail]), do: [(a < b) | cmp([b | tail])]

  defp cmp(_), do: []
end

"1.input"
|> Puzzle.solve()
|> IO.puts()
