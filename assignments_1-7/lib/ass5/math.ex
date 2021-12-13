defmodule Math do
  def add(num1, num2) do
    info("Adding #{num1} to #{num2}")
    IO.puts("#{num1 + num2}")
  end

  def sub(num1, num2) do
    info("Subtracting #{num1} from #{num2}")
    IO.puts("#{num1 - num2}")
  end

  def mul(num1, num2) do
    info("Multiplying #{num1} with #{num2}")
    IO.puts("#{num1 * num2}")
  end

  def div(num1, num2) do
    info("Dividing #{num1} with #{num2}")
    IO.puts("#{num1 / num2}")
  end

  defp info(print) do
    IO.puts(print)
  end
end
