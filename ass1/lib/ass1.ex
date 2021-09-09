defmodule Ass1 do
  @moduledoc """
  Documentation for `Ass1`.
  """

  @doc """
  Teacher's instructions for Part 1:

  Write an Elixir script that declares a variable and sets its value to 123.
  Print the value of the variable to the console.
  Add code that asks a text line from the user (use IO.gets).
  Add text <- You said that to the text that user entered.
  Print the combined text into the console.

  ## Examples

      iex(1)> c "lib/ass1.ex"
      [Ass1]
      iex(2)> Ass1.part1()
      Value of the variable is 123
      Type some text
      This is text
      You just typed This is text

      :ok
      iex(3)>

  """
  def part1 do
    someNumber = 123
    IO.puts("Value of the variable is #{someNumber}")
    someInput = IO.gets("Type some text\n")
    response = "You just typed #{someInput}"
    IO.puts(response)

  end
end
