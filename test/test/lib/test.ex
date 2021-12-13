defmodule RecursePrint do

  def print(count, stop, printable) do
    IO.puts "#{printable} #{count}"
    if count < stop do
      print(count+1, stop, printable)
    else
      :ok
    end
  end
end

defmodule ProcessTest do
  def do_one_thing(init, count \\ 0) do
    IO.puts "Doing one thing. Count: #{count}. Originally from: #{}"
    IO.inspect init
    :timer.sleep(1000)
    if count < 5 do do_other_thing(init, count+1) end
  end

  def do_other_thing(init, count \\ 0) do
    IO.puts "Doing other thing. Count: #{count}. Originally from: #{}"
    IO.inspect init
    :timer.sleep(1000)
    if count < 5 do do_one_thing(init, count+1) end
  end

  def mainloop do
    {:ok, pid} = TestServer.start_link([])
    TestServer.begin(pid, fn(state) -> ProcessTest.do_one_thing(pid) end)
    :timer.sleep(500)
    {:ok, pid} = TestServer.start_link([])
    TestServer.begin(pid, fn(state) -> ProcessTest.do_other_thing(pid) end)
  end
end

defmodule TestServer do

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [])
  end

  def begin(pid, func) do
    GenServer.cast(pid,{:start, func})
  end

  @impl true
  def handle_cast({:start, func}, state) do
    {:noreply, func.(state)}
  end

  @impl true
  def init(stack) do
    {:ok, stack}
  end
end

