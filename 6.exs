defmodule Puzzle do
  def solve(name) do
    name
    |> parse
    |> reproduce(256)
    |> Enum.sum
  end

  defp reproduce(lanternfish, 0), do: lanternfish

  defp reproduce(lanternfish, days) do
    lanternfish
    |> do_reproduce()
    |> reproduce(days - 1)
  end

  defp do_reproduce(lanternfish) do
    index           = 8
    new_lanternfish = List.duplicate(0, 9)

    lanternfish
    |> do_reproduce(index, new_lanternfish)
  end

  defp do_reproduce(old_list, 0, new_list) do
    prev_elem_0 = old_list |> Enum.at(0)
    prev_elem_6 = new_list |> Enum.at(6)

    new_list
    |> List.replace_at(8, prev_elem_0)
    |> List.replace_at(6, prev_elem_6 + prev_elem_0)
  end

  defp do_reproduce(old_list, index, new_list) do
    prev_elem = old_list |> Enum.at(index)

    nl = new_list |> List.replace_at(index-1, prev_elem)

    do_reproduce(old_list, index-1, nl)
  end

  defp to_integer(nil), do: 0
  defp to_integer(v), do: v

  defp parse(name) do
    name
    |> File.read
    |> Kernel.elem(1)
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(List.duplicate(0, 9), fn e, acc ->
      new_val = acc
                |> Enum.at(e)
                |> to_integer()
                |> Kernel.+(1)
      acc
      |> List.replace_at(e, new_val)
    end)
  end
end

"6.input"
|> Puzzle.solve
|> IO.inspect
