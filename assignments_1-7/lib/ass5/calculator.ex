defmodule Calculator do
  import Math

  def calc(calc_op) do
    stripped = String.trim_trailing(calc_op, "\n")
    is_calc = ~r/^\d+[\+\-\/\*]\d+$/

    if !String.match?(stripped, is_calc) do
      false
    else
      get_operation = ~r/^(?<num1>\d+)(?<operation>.)(?<num2>\d+)$/
      calc_map = Regex.named_captures(get_operation, stripped)
      operation = calc_map["operation"]
      num1 = elem(Integer.parse(calc_map["num1"]), 0)
      num2 = elem(Integer.parse(calc_map["num2"]), 0)

      cond do
        operation == "+" -> Math.add(num1, num2)
        operation == "-" -> Math.sub(num1, num2)
        operation == "*" -> Math.mul(num1, num2)
        operation == "/" -> Math.div(num1, num2)
      end

      true
    end
  end
end
