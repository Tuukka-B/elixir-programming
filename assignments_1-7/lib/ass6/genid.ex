defmodule GenId do
  def new do
    pid = spawn(fn -> loop(0) end)
    Process.register(pid, :Generator)
  end

  def get(pid) do
    send(pid, {:get, self()})

    receive do
      x -> x
    end
  end

  defp loop(n) do
    receive do
      {:get, from} ->
        send(from, n)
        loop(n + 1)
    end
  end
end
