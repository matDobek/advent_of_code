defmodule Puzzle do
  def solve(name) do
    commands = name
               |> Enum.map(fn str ->
                 [cmd, str_no] = str |> String.split()
                  no = str_no |> String.to_integer()

                 {cmd, no}
               end)

    commands
    |> move([0, 0, 0])
  end

  defp move([{"down", no} | tail], [x, y, aim]) do
    new_aim = aim + no

    move(tail, [x, y, new_aim])
  end

  defp move([{"up", no} | tail], [x, y, aim]) do
    new_aim = aim + (no * -1)

    move(tail, [x, y, new_aim])
  end

  defp move([{"forward", no} | tail], [x, y, aim]) do
    new_x = x + no
    new_y = y + (aim * no)
    new_aim = aim

    move(tail, [new_x, new_y, new_aim])
  end

  defp move(_, [x, y, _]), do: x * y
end

"2.input"
|> Helpers.read_input
|> Puzzle.solve
|> IO.puts()
