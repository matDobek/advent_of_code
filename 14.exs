defmodule Puzzle do
  def solve() do
    {template, occurances, rules} = "14.input" |> parse()

    steps(occurances, rules, 40)
    |> score(template)
    |> IO.inspect
  end

  defp score(occurances, orginal_template) do
    {{_, min}, {_, max}} =
      occurances
      |> Enum.reduce(%{}, fn {k, v}, acc ->
        [k1, _k2] = k |> String.graphemes

        Map.update(acc, k1, v, & &1 + v)
      end)
      |> Map.update(orginal_template |> String.last, 1, & &1 + 1)
      |> Map.to_list
      |> Enum.min_max_by(fn {_, v} -> v end)

    max - min
  end

  defp steps(template, _, 0), do: template
  defp steps(template, rules, i), do: apply_rules(template, rules) |> steps(rules, i-1)

  defp apply_rules(template, rules), do: template |> Map.to_list() |> apply_rules(%{}, rules)
  defp apply_rules([], new_template, _), do: new_template
  defp apply_rules([part | rest], new_template, rules), do: apply_rules(rest, update_template(part, new_template, rules), rules)

  defp update_template({k = <<k1::utf8>> <> <<k2::utf8>>, v}, new_template, rules) do
    new_template
    |> Map.update(<<k1::utf8>> <> rules[k], v, & &1 + v)
    |> Map.update(rules[k] <> <<k2::utf8>>, v, & &1 + v)
  end

  defp parse(input) do
    [template, rules] = input
                        |> File.read
                        |> Kernel.elem(1)
                        |> String.trim
                        |> String.split("\n\n")

    { template, parse_template(template), parse_rules(rules) }
  end

  defp parse_template(template), do: template |> parse_template(%{})
  defp parse_template(<<_::utf8>>, dict), do: dict
  defp parse_template(<<a::utf8>> <> <<b::utf8>> <> rest, dict) do
    key = <<a::utf8>> <> <<b::utf8>>
    dict = Map.update(dict, key, 1, & &1+1)

    parse_template(<<b::utf8>> <> rest, dict)
  end

  defp parse_rules(rules) do
    rules
    |> String.split("\n")
    |> Enum.map(fn str ->
      str |> String.split(" -> ") |> List.to_tuple
    end)
    |> Map.new
  end
end

Puzzle.solve
