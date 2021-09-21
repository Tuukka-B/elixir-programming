defmodule Ass3 do
  @moduledoc """
  Documentation for `Ass1`.
  """

  @doc """
  ## Teacher's instructions for Part 1:

    Implement a Elixir script that:

    Ask a number from the user.
    If given number is evenly divisible by 3, print Divisible by 3.
    If given number is evenly divisible by 5, print Divisible by 5.
    If given number is evenly divisible by 7, print Divisible by 7.
    If given number is not evenly divisible by 3, 5 or 7, find smallest value (excluding 1) that number is evenly divisible for and print that value to the output.

 

  ## Teacher's instructions for Part 2

    Write an anonymous function that takes two parameters:

    Use a guard to check if both parameters are a string type. If so, return a combined string of the parameters.
    If parameters are not strings, return the addition result of the parameters.
    Test your anonymous function with string and number parameters and print the results.

  ## Examples

    user@localhost:~/M2296/elixir-programming/assignments$ elixir lib/ass3.exs
    === PART 1 ===
    Give a number
    97
    The number is divisible by 97
    == FINISHED ==

    === PART 2 ===
    The addition of numbers 1 and 2 is 3
    The combined string of "yes" and "no" is "yesno"
    The input types of "yes" and "2" are incompatible with each other
    == FINISHED ==

    user@localhost:~/M2296/elixir-programming/assignments$


"""

  def part1 do
    IO.puts("=== PART 1 ===")

    number = elem(Integer.parse(String.trim_trailing(IO.gets("Give a number\n"), "\n")), 0)

    cond do
      rem(number, 3) == 0 -> IO.puts "The number is divisible by #{3}"
      rem(number, 5) == 0 -> IO.puts "The number is divisible by #{5}"
      rem(number, 7) == 0 -> IO.puts "The number is divisible by #{7}"
      number == 1 -> IO.puts "Number is #{1}, and its smallest divisor is #{1}"
      true -> Ass3.find_lowest_denominator(number, 2)
    end

    IO.puts "== FINISHED ==\n"
  end

  def part2 do
    IO.puts("=== PART 2 ===")
    combine_inputs = fn
      {input1, input2} when is_binary(input1) and is_binary(input2) -> IO.puts "The combined string of \"#{input1}\" and \"#{input2}\" is \"#{input1 <> input2}\""
      {input1, input2} when is_integer(input1) and is_integer(input2) -> IO.puts "The addition of numbers #{input1} and #{input2} is #{input1 + input2}"
      {input1, input2} -> IO.puts "The input types of \"#{input1}\" and \"#{input2}\" are incompatible with each other"
    end

    combine_inputs.({1, 2});
    combine_inputs.({"yes", "no"});
    combine_inputs.({"yes", 2});
    IO.puts "== FINISHED ==\n"

  end

  def find_lowest_denominator(number, divisor) do
    unless rem(number, divisor) == 0 do
      Ass3.find_lowest_denominator(number, divisor + 1)
    else IO.puts "The number is divisible by #{divisor}"
    end
  end

end

Ass3.part1()
Ass3.part2()
