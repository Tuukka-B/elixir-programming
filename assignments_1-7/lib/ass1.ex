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

  ## Teacher's instructions for Part 4:

    Write an anonymous function that takes three parameters and calculates a product (multiplication) of those three values.
    Ask three numbers from user (use IO.gets and String.to_integer) and pass them to your function created in step 1.
    Print the result to the console.
    Write an anonymous function that concats two lists and returns the result.
    Call the list concat function and print the results.
    Declare a tuple with atoms ok and fail.
    Add new atom canceled and print the combined tuple.


  ## Examples

      user@localhost:~/M2296/elixir-programming/assignments_1-7$ iex -S mix
      iex(1)> Ass1.ass1_mainloop
      === PART 1 ===
      Value of the variable is 123
      Type some text
      This is text
      You just typed This is text

      === PART 2 ===
      Result of 154 divided by 78 is 1.9743589743589745
      Integer result of 154 divided by 78 is 1
      Rounded result of 154 divided by 78 is 2
      == FINISHED ==

      === PART 3 ===
      Type some text
      This is a foo text
      You typed 18 amount of characters
      You typed txet oof a si sihT in reverse
      If we replace all occurences of 'foo' from your typed text with 'bar', we get This is a bar text

      == FINISHED ==

      === PART 4 ===
      Give a number
      3
      Give a number
      4
      Give a number
      5
      Your input is 60 multiplied
      List 1 is 1, 2, 3, list 2 is 4, 5, 6
      The lists put together are 1, 2, 3, 4, 5, 6
      In the beginning we have a tuple with values ok, fail and we extend it with value of canceled
      The extended tuple then will be ok, fail, canceled
      == FINISHED ==

  """
  def part1 do
    IO.puts("=== PART 1 ===")
    someNumber = 123
    IO.puts("Value of the variable is #{someNumber}")
    someInput = IO.gets("Type some text\n")
    response = "You just typed #{someInput}"
    IO.puts(response)
  end

  def part2 do
    IO.puts("=== PART 2 ===")
    {num1, num2} = {154, 78}
    someNumber = num1 / num2
    rounded = round(someNumber)
    integerPart = div(num1, num2)
    IO.puts("Result of #{num1} divided by #{num2} is #{someNumber}")
    IO.puts("Integer result of #{num1} divided by #{num2} is #{integerPart}")
    IO.puts("Rounded result of #{num1} divided by #{num2} is #{rounded}")
    IO.puts("== FINISHED ==\n")
  end

  def part3 do
    IO.puts("=== PART 3 ===")
    someString = IO.gets("Type some text\n")

    # for some reason we need to substract 1 from the string length to get the actual string length
    IO.puts("You typed #{String.length(someString) - 1} amount of characters")
    IO.puts("You typed #{String.reverse(String.trim_trailing(someString, "\n"))} in reverse")

    IO.puts(
      "If we replace all occurences of 'foo' from your typed text with 'bar', we get #{String.replace(someString, "foo", "bar")}"
    )

    IO.puts("== FINISHED ==\n")
  end

  def part4 do
    IO.puts("=== PART 4 ===")
    multiply = fn num1, num2, num3 -> num1 * num2 * num3 end
    concat = fn list, anotherlist -> Enum.concat(list, anotherlist) end
    [num3, num2, num1] = Ass1.getInput(3, [])
    IO.puts("Your input is #{multiply.(num1, num2, num3)} multiplied")

    list1 = [1, 2, 3]
    list2 = [4, 5, 6]
    IO.puts("List 1 is #{Enum.join(list1, ", ")}, list 2 is #{Enum.join(list2, ", ")}")
    IO.puts("The lists put together are #{Enum.join(concat.(list1, list2), ", ")}")

    someTuple = {:ok, :fail}
    # tuples can't be concatenated so we use a work-around
    extendedTuple = List.to_tuple(Tuple.to_list(someTuple) ++ [:canceled])

    IO.puts(
      "In the beginning we have a tuple with values #{Enum.join(Tuple.to_list(someTuple), ", ")} and we extend it with value of #{:canceled}"
    )

    IO.puts("The extended tuple then will be #{Enum.join(Tuple.to_list(extendedTuple), ", ")}")
    IO.puts("== FINISHED ==\n")
  end

  ## recursive function to get n (num) amount of inputs from the user and return them as an integer array
  def getInput(num, arr) when num == 0 do
    arr
  end

  def getInput(num, arr) do
    Ass1.getInput(num - 1, [
      String.to_integer(String.trim_trailing(IO.gets("Give a number\n"), "\n")) | arr
    ])
  end

  def ass1_mainloop do
    part1()
    part2()
    part3()
    part4()
  end
end
