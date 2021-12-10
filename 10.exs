defmodule Puzzle do
  def solve(name) do
    name
    |> parse
    |> Enum.map(&reduced_form/1)
    |> Enum.reject(&corrupted?/1)
    |> Enum.map(&missing_symbols/1)
    |> Enum.map(&score/1)
    |> middle
  end

  defp score(col) do
    Enum.reduce(col, 0, fn sym, acc ->
      %{
        ")" => 1,
        "]" => 2,
        "}" => 3,
        ">" => 4,
      }[sym] + acc*5
    end)
  end

  defp middle(col) do
    len = col |> length()
    index = floor(len/2)

    col
    |> Enum.sort
    |> Enum.at(index)
  end

  defp missing_symbols(str) do
    str
    |> String.reverse
    |> String.graphemes
    |> Enum.map(&reverse_symbol/1)
  end

  defp reverse_symbol("{"), do: "}"
  defp reverse_symbol("["), do: "]"
  defp reverse_symbol("("), do: ")"
  defp reverse_symbol("<"), do: ">"

  defp corrupted?(""), do: false
  defp corrupted?(<<head::utf8>> <> _rest) when head in [?>, ?), ?}, ?]], do: true
  defp corrupted?(<<_head::utf8>> <> rest), do: corrupted?(rest)

  defp reduced_form(str), do: reduced_form("", str)
  defp reduced_form(str, str), do: str
  defp reduced_form(_, str), do: reduced_form(str, reduce(str))

  defp reduce(str), do: reduce(str, "")
  defp reduce("", acc), do: acc |> String.reverse
  defp reduce("{}" <> rest, acc), do: reduce(rest, acc)
  defp reduce("[]" <> rest, acc), do: reduce(rest, acc)
  defp reduce("<>" <> rest, acc), do: reduce(rest, acc)
  defp reduce("()" <> rest, acc), do: reduce(rest, acc)
  defp reduce(<<head::utf8>> <> rest, acc), do: reduce(rest, <<head::utf8>> <> acc)

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
