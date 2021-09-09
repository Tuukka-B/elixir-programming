defmodule Ass1 do
  @moduledoc """
  Documentation for `Ass1`.
  """

  @doc """
  ## Teacher's instructions for Part 1:

    Write an Elixir script that declares a variable and sets its value to 123.
    Print the value of the variable to the console.
    Add code that asks a text line from the user (use IO.gets).
    Add text <- You said that to the text that user entered.
    Print the combined text into the console.

  ## Teacher's instructions for Part 2:

    Write an Elixir script that calculates the result of 154 divided by 78 and prints it to the console.
    Get the result of calculation (step 1) rounded to nearest integer and print it to console.
    Get the result of calculation (step 1) and print only the integer part of it into the console.


  ## Teacher's instructions for Part 3:

    Ask a line of text from the user (use IO.gets).
    Print the number of characters in string that user entered.
    Print the entered text in reverse.
    Replace the word foo in entered text with bar and print resulted string into the console.


  ## Examples

      iex(1)> c "lib/ass1.ex"
      [Ass1]
      iex(2)> Ass1.part1()
      Value of the variable is 123
      Type some text
      This is text
      You just typed This is text

      :ok
      iex(3)> Ass1.part2()
      Result of 154 divided by 78 is 1.9743589743589745
      Integer result of 154 divided by 78 is 1
      Rounded result of 154 divided by 78 is 2
      :ok
      iex(4)>

  """
  def part1 do
    someNumber = 123
    IO.puts("Value of the variable is #{someNumber}")
    someInput = IO.gets("Type some text\n")
    response = "You just typed #{someInput}"
    IO.puts(response)

  end

  def part2 do
    {num1, num2} = {154, 78}
    someNumber = num1 / num2
    rounded = round(someNumber)
    integerDiv = div(num1, num2)
    IO.puts("Result of #{num1} divided by #{num2} is #{someNumber}")
    IO.puts("Integer result of #{num1} divided by #{num2} is #{integerDiv}")
    IO.puts("Rounded result of #{num1} divided by #{num2} is #{rounded}")

  end
  def part3 do
    someString = IO.gets("Type some text\n")
    IO.puts("You typed #{String.length(someString)-1} amount of characters") # for some reason we need to substract 1 from the string length to get the actual length
    IO.puts("You typed #{String.reverse(someString)} in reverse")
    IO.puts("If we replace all occurences of 'foo' from your typed text with 'bar', we get #{String.replace(someString, "foo", "bar")}")

  end
end
