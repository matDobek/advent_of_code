defmodule Puzzle do
  def solve(name) do
    name
    |> parse
    |> incomplete
    |> Enum.map(fn str ->
      str
      |> String.reverse
      |> String.graphemes
      |> Enum.map(&reverse_symbol/1)
    end)
    |> Enum.map(fn col ->
      Enum.reduce(col, 0, fn sym, acc ->
        %{
          ")" => 1,
          "]" => 2,
          "}" => 3,
          ">" => 4,
        }[sym] + acc*5
      end)
    end)
    |> Enum.sort
    |> middle
  end

  defp middle(col) do
    len = col |> length()
    index = floor(len/2)

    Enum.at(col, index)
  end

  defp reverse_symbol("{"), do: "}"
  defp reverse_symbol("["), do: "]"
  defp reverse_symbol("("), do: ")"
  defp reverse_symbol("<"), do: ">"

  defp incomplete([]), do: []

  defp incomplete([str | tail]) do
    reduced_form = str |> keep_reducing

    case reduced_form |> invalid_symbol do
      nil -> [reduced_form | incomplete(tail)]
      _ -> incomplete(tail)
    end
  end

  defp keep_reducing(str) do
    new_str = reduce(str)
    case String.length(new_str) == String.length(str) do
      true -> new_str
      _ -> keep_reducing(new_str)
    end
  end

  defp reduce(str), do: reduce(str, "")
  defp reduce("", acc), do: acc |> String.reverse
  defp reduce("{}" <> rest, acc), do: reduce(rest, acc)
  defp reduce("[]" <> rest, acc), do: reduce(rest, acc)
  defp reduce("<>" <> rest, acc), do: reduce(rest, acc)
  defp reduce("()" <> rest, acc), do: reduce(rest, acc)
  defp reduce(<<head::utf8>> <> rest, acc), do: reduce(rest, <<head::utf8>> <> acc)

  defp invalid_symbol(""), do: nil
  defp invalid_symbol(<<head::utf8>> <> _rest) when <<head::utf8>> in [">", ")", "}", "]"], do: <<head::utf8>>
  defp invalid_symbol(<<_head::utf8>> <> rest), do: invalid_symbol(rest)

  defp parse(name) do
    name
    |> File.read
    |> Kernel.elem(1)
    |> String.trim
    |> String.split("\n")
  end
end

"10.input"
|> Puzzle.solve
|> IO.inspect
