defmodule Puzzle do
  def solve(input) do
    [coords, fold_points] = parse(input)

    coords
    |> build_paper
    |> keep_folding(fold_points)
    |> print
  end

  defp build_paper(coords) do
    x_max = coords |> Enum.reduce(0, fn {n, _}, n_max -> [n, n_max] |> Enum.max end)
    y_max = coords |> Enum.reduce(0, fn {_, n}, n_max -> [n, n_max] |> Enum.max end)

    row = List.duplicate(0, x_max+1)
    paper = List.duplicate(row, y_max+1)

    build_paper(coords, paper)
  end
  defp build_paper([], paper), do: paper
  defp build_paper([point | points], paper), do: build_paper(points, mark_at(point, paper))

  defp mark_at({x, y}, paper) do
    row = paper |> Enum.at(y) |> List.replace_at(x, 1)

    List.replace_at(paper, y, row)
  end

  defp keep_folding(paper, []), do: paper
  defp keep_folding(paper, [point | points]), do: paper |> fold_at(point) |> keep_folding(points)

  defp fold_at(paper, {:x, i}) do
    paper
    |> Enum.map(fn row ->
      {_, row} = List.pop_at(row, i)
      row
    end)
    |> Enum.map(fn row ->
      {left, right} = row |> Enum.split(i)

      merge(left, right |> Enum.reverse)
    end)
  end

  defp fold_at(paper, {:y, i}) do
    {_, paper} = paper |> List.pop_at(i)
    {top_paper, bottom_paper} = paper |> Enum.split(i)

    merge_row(top_paper, bottom_paper |> Enum.reverse)
  end

  defp merge_row([], []), do: []
  defp merge_row([], bottom), do: bottom
  defp merge_row(top, []), do: top
  defp merge_row([v1 | top], [v2 | bottom]), do: [merge(v1, v2) | merge_row(top, bottom)]

  defp merge([], []), do: []
  defp merge(as, []), do: as
  defp merge([], bs), do: bs
  defp merge([a | as], [b | bs]), do: [a+b | merge(as, bs)]

  defp parse(input) do
    [coords, folds] = input
                      |> File.read
                      |> Kernel.elem(1)
                      |> String.trim
                      |> String.split("\n\n")

    [
      coords
      |> String.split("\n")
      |> Enum.map(fn str ->
        [x, y] = String.split(str, ",")

        {String.to_integer(x), String.to_integer(y)}
      end),

      folds
      |> String.split("\n")
      |> Enum.map(&parse_fold/1)
    ]
  end

  defp parse_fold("fold along x=" <> val), do: {:x, String.to_integer(val)}
  defp parse_fold("fold along y=" <> val), do: {:y, String.to_integer(val)}

  defp print(col) do
    col
    |> Enum.map(fn row ->
      Enum.map(row, &(if &1 > 0, do: "#", else: "."))
      |> Enum.join
    end)
    |> Enum.join("\n")
    |> IO.puts
  end
end

"13.input"
|> Puzzle.solve
|> IO.inspect
