defmodule Puzzle do
  def solve(input, boards) do
    mark(input, boards, 0)
  end

  defp mark([], boards, _), do: boards

  defp mark([x | _], [board], y) do
    a = board
        |> List.flatten
        |> Enum.filter(fn {_, pred} -> pred == false end)
        |> Enum.map(fn {num, _p} -> num end)
        |> Enum.sum
    (a-x) * x
  end

  defp mark([x | xs], boards, y) do
    updated_boards = update_boards(x, boards)

    IO.inspect("- - - - - - - - - -")
    case find_winning_board(x, updated_boards, []) do
      nil ->
        IO.inspect("No board found")
        mark(xs, updated_boards, x)
      boards ->
        IO.inspect("Found winning board.")
        reduced = updated_boards -- boards
        IO.inspect("Previously: #{boards |> length}. Now: #{reduced |> length}")
        mark(xs, reduced, x)
    end
  end

  defp update_boards(_, []), do: []

  defp update_boards(x, [board | boards]) do
    updated_board = board
                    |> Enum.map(fn {no_on_board, flag} ->
                      case no_on_board == x do
                        true -> {no_on_board, true}
                        _ -> {no_on_board, flag}
                      end
                    end)

    [updated_board | update_boards(x, boards)]
  end

  defp find_winning_board(_, [], []), do: nil
  defp find_winning_board(_, [], boards), do: boards

  defp find_winning_board(x, [board | boards], winning_boards) do
    horizontal = board
                 |> Enum.chunk_every(5)
                 |> Enum.map(fn row ->
                   row |> Enum.all?(fn {_num, p} -> p end)
                 end)
                 |> Enum.any?

    vertical = board
               |> Enum.chunk_every(5)
               |> List.zip
               |> Enum.map(&Tuple.to_list/1)
               |> Enum.map(fn row ->
                 row |> Enum.all?(fn {_num, p} -> p end)
               end)
               |> Enum.any?

    r = cond do
      horizontal ->
        winning_row = board
                      |> Enum.chunk_every(5)
                      |> Enum.find(fn row ->
                        row |> Enum.all?(fn {_num, p} -> p end)
                      end)
        rest = (board |> Enum.chunk_every(5)) -- [winning_row]

        b = rest
            |> List.flatten
            |> Enum.filter(fn {_, pred} -> pred == false end)
            |> Enum.map(fn {num, _p} -> num end)
            |> Enum.sum

        b*x

      vertical ->
        winning_row = board
                      |> Enum.chunk_every(5)
                      |> List.zip
                      |> Enum.map(&Tuple.to_list/1)
                      |> Enum.find(fn row ->
                        row |> Enum.all?(fn {_num, p} -> p end)
                      end)
        rest = (board |> Enum.chunk_every(5) |> List.zip |> Enum.map(&Tuple.to_list/1)) -- [winning_row]

        b = rest
            |> List.flatten
            |> Enum.filter(fn {_, pred} -> pred == false end)
            |> Enum.map(fn {num, _p} -> num end)
            |> Enum.sum

        b*x

      true -> false
    end

    case horizontal || vertical do
      true -> find_winning_board(x, boards, [board | winning_boards])
      _ -> find_winning_board(x, boards, winning_boards)
    end
  end
end





{:ok, str} = File.read("4.input")

[numbers | boards] = str
                     |> String.split("\n\n")

new_numbers = numbers
              |> String.split(",")
              |> Enum.map(&String.to_integer/1)
#
# o o o o o
# o o o o o
# o o o o o
# o o o o o
# o o o o o
#

new_boards = boards
             |> Enum.map(fn board ->
               board
               |> String.trim()
               |> String.split("\n")
               |> Enum.map(fn row ->
                 row
                 |> String.split()
                 |> Enum.map(fn no -> {no |> String.to_integer, false} end)
               end)
               |> List.flatten
             end)

Puzzle.solve(new_numbers, new_boards)
|> IO.inspect()
