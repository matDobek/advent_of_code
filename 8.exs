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
    |> Enum.find_index(fn str -> compare(str, number) end)
    |> Integer.to_string
    |> Kernel.<>(decode(signals, tail))
  end

  defp compare(str1, str2) do
    a = str1 |> String.graphemes |> Enum.sort
    b = str2 |> String.graphemes |> Enum.sort

    a == b
  end

  defp signal_patterns(unique_signals) do
    sig_1 = unique_signals |> Enum.find(fn str -> String.length(str) == 2 end)
    sig_4 = unique_signals |> Enum.find(fn str -> String.length(str) == 4 end)
    sig_7 = unique_signals |> Enum.find(fn str -> String.length(str) == 3 end)
    sig_8 = unique_signals |> Enum.find(fn str -> String.length(str) == 7 end)

    sig_069 = unique_signals |> Enum.filter(fn str -> String.length(str) == 6 end)
    sig_235 = unique_signals |> Enum.filter(fn str -> String.length(str) == 5 end)

    sig_6 = sig_069
            |> Enum.filter(fn str ->
              diff = String.graphemes(str) -- String.graphemes(sig_1)

              length(diff) == 5
            end)
            |> List.first

    sig_0 = (sig_069 -- [sig_6])
            |> Enum.filter(fn str ->
              diff = String.graphemes(str) -- String.graphemes(sig_4)

              length(diff) == 3
            end)
            |> List.first

    sig_9 = (sig_069 -- [sig_6, sig_0])
            |> List.first

    sig_3 = sig_235
            |> Enum.filter(fn str ->
              diff = String.graphemes(str) -- String.graphemes(sig_7)

              length(diff) == 2
            end)
            |> List.first

    sig_2 = (sig_235 -- [sig_3])
            |> Enum.filter(fn str ->
              diff = String.graphemes(str) -- String.graphemes(sig_6)

              length(diff) == 1
            end)
            |> List.first

    sig_5 = (sig_235 -- [sig_3, sig_2])
            |> List.first

    [sig_0, sig_1, sig_2, sig_3, sig_4, sig_5, sig_6, sig_7, sig_8, sig_9]
  end

  defp parse(name) do
    name
    |> File.read
    |> Kernel.elem(1)
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(" | ")
      |> Enum.map(fn str ->
          str
          |> String.split
      end)
    end)
  end
end

"8.input"
|> Puzzle.solve
|> IO.inspect
