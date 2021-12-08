defmodule Puzzle do
  def solve(name) do
    name
    |> parse
    |> Enum.map(fn [unique_signals, number] ->
      unique_signals
      |> signal_patterns
      |> decode(number)
      |> String.to_integer
    end)
    |> Enum.sum
  end

  defp decode(_signals, []), do: ""

  defp decode(signals, [number | tail]) do
    signals
    |> Map.get(number |> to_charlist |> Enum.sort)
    |> Integer.to_string
    |> Kernel.<>(decode(signals, tail))
  end

  #
  # Updated version
  # Based on: https://github.com/ruslandoga/advent-2021-elixir/blob/master/lib/day8.ex
  #
  defp signal_patterns(unique_signals) do
    %{
      2 => [sig_1],
      3 => [sig_7],
      4 => [sig_4],
      5 => sig_235,
      6 => sig_069,
      7 => [sig_8],
    } = Enum.group_by(unique_signals, &String.length/1, fn str ->
      str |> to_charlist |> Enum.sort
    end)

    [sig_9, sig_0, sig_6] =
      Enum.sort_by(sig_069, fn chars ->
        # 9 -> 4 + 2
        # 0 -> 4 + 3
        # 6 -> 5 + 3

        length(chars -- sig_1) + length(chars -- sig_4)
      end)

    [sig_3, sig_5, sig_2] =
      Enum.sort_by(sig_235, fn chars ->
        # 3 -> 3 + 2
        # 5 -> 4 + 2
        # 2 -> 4 + 3

        length(chars -- sig_1) + length(chars -- sig_4)
      end)

    [sig_0, sig_1, sig_2, sig_3, sig_4, sig_5, sig_6, sig_7, sig_8, sig_9]
    |> Enum.with_index
    |> Map.new
  end

  defp parse(name) do
    name
    |> File.read
    |> Kernel.elem(1)
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.split(" | ") |> Enum.map(&String.split/1) end)
  end
end

"8.input"
|> Puzzle.solve
|> IO.inspect
