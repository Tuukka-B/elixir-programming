defmodule ProcessInfo do
  @enforce_keys [:name, :function, :args]
  defstruct [:name, :function, :args]
end

defmodule PeriodicalExecutor do
  import TaskStorage

  # Client
  def start(default) do
    GenServer.start(__MODULE__, default)
  end

  # Server internal functions
  defp exec_process(process, storage) do
    state = TaskStorage.get(storage)
    process_in_state = Enum.find(state, fn (repeated_process) -> process.details.name == repeated_process.details.name end)
    if (process_in_state) do
      # TO-DO: should I check also for other changed attributes?
      if (process_in_state.repeat_time != process.repeat_time) do
        cond do
          process_in_state.repeat_time > process.repeat_time -> 
            # repeat time was grown -> delay execution of process, update information of process
            Process.send_after(self(), 
            {:execute, process_in_state}, process_in_state.repeat_time - process.repeat_time)
            storage
          process_in_state.repeat_time < process.repeat_time ->
            # repeat time was lessened -> next iteration will repeat in the correct time
            execute_and_check_cancel_on_return(process_in_state, storage)
        end
      else
        execute_and_check_cancel_on_return(process, storage)
      end
    else
      send(self, :terminate)
      storage
    end
  end

  defp execute_and_check_cancel_on_return(process, storage) do
    try do
      result = apply(process.details.function, process.details.args)
      case is_map_key(process, :cancel_on_return) do
        true ->
          case result == process.cancel_on_return do
            true ->
              IO.puts "Process of name #{process.details.name} canceled by return value of \"#{process.cancel_on_return}\""
              TaskStorage.delete(storage, process)
              send(self, :terminate)
              storage
            false ->
              Process.send_after(self(), {:execute, process}, process.repeat_time)
              storage
          end
        false ->
          Process.send_after(self(), {:execute, process}, process.repeat_time)
          storage
      end
    rescue 
      e ->
        IO.puts "Fatal error encountered while trying to execute a periodical task. Error details: \n
        \r#{Exception.format(:error, e)}\n
        \rTask will now be canceled. Please check you are using the correct number of arguments for the task you want to invoke!"
        TaskStorage.delete(storage, process)
        send(self, :terminate)
        storage
    end
  end

  # Server
  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def handle_info({:execute, new_process_name}, storage) do
    {:noreply, exec_process(new_process_name, storage)}
  end

  @impl true
  def handle_info(:terminate, storage) do
      {:stop, :normal, storage}
  end


end

defmodule PeriodicalTimer do
  import TaskStorage
  import ProcessInfo
  import PeriodicalExecutor
  use GenServer
  @enforce_keys [:details, :repeat_time]
  defstruct [:details, :repeat_time, :cancel_on_return]

  def reschedule_process(pid, name, interval) do
    GenServer.cast(pid, {:reschedule, name, interval})
  end

  def schedule_process(pid, args) do
    {process, interval, cancel_on_return} = args
    GenServer.call(pid, {:schedule, process, interval, cancel_on_return})
  end

  def cancel_process(pid, process_name) do
    GenServer.call(pid, {:cancel, process_name})
  end

  def get_processes(pid) do
    GenServer.call(pid, :get)
  end

  def is_name_taken(pid, name) do
    GenServer.call(pid, {:get, name})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: MyPeriodicalTimer)
  end


  # Server internal functions
  
  defp add_process(new_process, storage) do
    if (check_name(new_process.details.name, storage)) do
      storage
    else
      {:ok, pid} = PeriodicalExecutor.start(storage)
      TaskStorage.put(storage, new_process)
      Process.send_after(pid, {:execute, new_process}, new_process.repeat_time)
      storage
    end
    
  end

  defp check_name(name, storage) do
    processes = TaskStorage.get(storage)
    Enum.find_value(processes, fn (repeated_process) -> repeated_process.details.name == name && true || false end)
  end

  defp find_process(name, storage) do
    TaskStorage.find(storage, name)
  end

  defp find_and_reschedule(name, new_interval, storage) do
    process = TaskStorage.find(storage, name)
    if process == nil do IO.puts "No process to reschedule!" else IO.puts "Process rescheduled!" end
    TaskStorage.delete(storage, process)
    TaskStorage.put(storage, %PeriodicalTimer{details: process.details, repeat_time: new_interval})
    storage
  end

  defp remove_process(name, storage) do
    process = TaskStorage.find(storage, name)
    process && TaskStorage.delete(storage, process)
    storage
  end

  defp print_tasks(storage) do
    tasks = TaskStorage.get(storage)
    if length(tasks) != 0 do
    IO.puts "Your tasks:"
    Enum.each(tasks, fn (%_{details: %_{name: task_name, function: task, args: task_args}, repeat_time: interval}) -> 
      IO.puts "Task named \"#{task_name}\" with parameters of \"#{List.to_string(task_args)}\" and a repeat time of #{interval}" end) 
    else
      IO.puts "No tasks yet, add a new one!"
    end 
    
  end

  # Server (callbacks)

  @impl true
  def handle_call({:schedule, process, interval, cancel_on_return}, _from, processes ) do
    repeated_process = {:error, "not implemented"} != cancel_on_return &&
    %PeriodicalTimer{details: process, repeat_time: interval, cancel_on_return: cancel_on_return} ||
    %PeriodicalTimer{details: process, repeat_time: interval}
    {:reply, !check_name(process.name, processes), add_process(repeated_process, processes)}
  end

  @impl true
  def handle_call({:cancel, name}, _from, storage) do
    {:reply, check_name(name, storage) && :ok || {:error, "not found"}, remove_process(name, storage)}
  end

  @impl true
  def handle_call(:get, _from, storage) do
    {:reply, print_tasks(storage), storage}
  end

  @impl true
  def handle_call({:get, name}, _from, storage) do
    {:reply, check_name(name, storage), storage}
  end

  @impl true
  def handle_cast({:reschedule, name, interval}, storage) do
    {:noreply, find_and_reschedule(name, interval, storage)}
  end

  @impl true
  def init(_opts) do
    pid = Process.whereis(TaskStorage)
    if pid do
      {:ok, pid}
    else
      TaskStorage.start_link()
    end

  end
end
