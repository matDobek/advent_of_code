# elixir -r helpers.ex 1.exs

defmodule Helpers do
  def read_input(name) do
    name
    |> File.read()
    |> Kernel.elem(1)
    |> String.trim()
    |> String.split("\n")
  end
end
