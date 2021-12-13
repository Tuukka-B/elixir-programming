defmodule Ass5 do
  @moduledoc """
  Documentation for `Ass5`.
  """

  @doc """
  ## Teacher's instructions for the assignment:

    Copy the source code to Moodle return box. Alternatively you can paste a link to GitLab. If using GitLab, verify that you have added at least a Reporter permission for the lecturer.

        Create a source file math.ex and declare a module Math.
        Declare functions Math.add, Math.sub, Math.mul, and Math.div, each taking two parameters.
        Declare a private function Math.info which prints info from above public functions
            - The Math.add calls Math.info which prints "Adding x and y" (x and y the actual parameters to Math.add)
            - Use Math.info similarly from sub, mul and div functions.

        Create a source file calculator.ex and declare module Calculator.
        Declare a function Calculator.calc that takes a string parameter.
            - From string parameter, parse a number, operator (+,-,*,/) and second number, for example 123+456
            - Call the corresponding Math function based on parsed operator and two numbers.

        Create a script that has a loop that asks a string from user
        The text user enters is passed to Calculator.calc function
        Exit the loop if user enters text that does not parse correctly in Calculator.calc

    ## Examples
        user@localhost:~/M2296/elixir-programming/assignments_1-7$ iex -S mix
        iex(1)> Ass5.ass5_mainloop
        Type a calculation to calculate: 10+1
        Adding 10 to 1
        11
        Type a calculation to calculate: 10-1
        Subtracting 10 from 1
        9
        Type a calculation to calculate: 10*2
        Multiplying 10 with 2
        20
        Type a calculation to calculate: 10/2
        Dividing 10 with 2
        5.0
        Type a calculation to calculate: 10
        Input was incorrect! Quitting...
        warning: unused import Calculator
        lib/ass5/ass5.ex:29

        [Ass5]
        iex(4)>

  """

  def ass5_mainloop do
    import Calculator
    calculation = IO.gets("Type a calculation to calculate: ")
    result = Calculator.calc(calculation)

    if result == false do
      IO.puts("Input was incorrect! Quitting...")
    else
      ass5_mainloop()
    end
  end
end
