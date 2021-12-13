

defmodule Ass8 do
  @moduledoc """
    Documentation for `Ass8`.
    """

    @doc """
      ## Teacher's instructions for the assignment:
        Copy the source code to Moodle return box. Alternatively you can paste a link to GitLab. If using GitLab, verify that you have added at least a Reporter permission for the lecturer.
        Use a GenServer to produce general purpose periodical timer
          - An interface to start periodical timer with period in milliseconds and function to be called when timer triggers.
          - Option to cancel the timer per return value (:ok or :cancel) of the passed function.
          - Option to cancel the timer via public interface.

      ## Examples
        user@localhost:~/M2296/elixir-programming/assignment_8$ iex -S mix
        Erlang/OTP 24 [erts-12.1.5] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

        Compiling 3 files (.ex)
        iex(1)> Ass8.ass8_mainloop
        Please choose from following operations: 'list', 'schedule', 'reschedule', 'cancel', 'quit' or 'e' to escape back to menu during any operation: schedule
        Give a module name to execute: IO
        Give a function name to execute from the module: puts
        Give a parameter or 'n' + return to finish (empty input is discarded): HELLO
        Give a parameter or 'n' + return to finish (empty input is discarded): n
        Give a name to refer this task to: test
        Give an interval in milliseconds to repeat this task: 3500
        Do you want to specify a return value for the function to terminate its repetition (y/n)? n
        Operation scheduled successfully!
        HELLO                                                                                                                                           
        Please choose from following operations: 'list', 'schedule', 'reschedule', 'cancel', 'quit' or 'e' to escape back to menu during any operation: list
        Your tasks:
        Task named "test" with parameters of "HELLO" and a repeat time of 3500
        HELLO                                                                                                                                           
        Please choose from following operations: 'list', 'schedule', 'reschedule', 'cancel', 'quit' or 'e' to escape back to menu during any operation: schedule
        HELLO                          
        Give a module name to execute: IO
        Give a function name to execute from the module: puts
        HELLO                                                                  
        HELLO                                                                        
        Give a parameter or 'n' + return to finish (empty input is discarded): test2 
        Give a parameter or 'n' + return to finish (empty input is discarded): n
        HELLO                              
        Give a name to refer this task to: test2
        HELLO                                                 
        Give an interval in milliseconds to repeat this task: 10000
        HELLO                                                                                     
        Do you want to specify a return value for the function to terminate its repetition (y/n)? y
        HELLO                                                                                             
        Specify a return value to auto-cancel repetition (start the input with ":" to create an atom): :ok
        Operation scheduled successfully!
        HELLO                                                                                                                                           
        Please choose from following operations: 'list', 'schedule', 'reschedule', 'cancel', 'quit' or 'e' to escape back to menu during any operation: cancel
        Input the name of a task you want to cancel: test
        Task canceled succesfully!
        test2                                                                                                                                           
        Process of name test2 canceled by return value of "ok"                                                                                          
        Please choose from following operations: 'list', 'schedule', 'reschedule', 'cancel', 'quit' or 'e' to escape back to menu during any operation: quit
        Quitting...
        :ok
        iex(2)> 
  """
  
  defp ask_cancel_on_return() do
    cancel_choice_validator = fn (input) -> (input == "y"  || input == "n") && input || false end
    cancel_on_return_validator = fn (input) -> 
      try do 
        if (String.at(input, 0) == ":") do 
          input 
          |> String.slice(1..String.length(input))
          |> String.to_atom()
        else
          input
        end 
      rescue _e -> 
        IO.puts "Failed to form an atom..."
        false 
      end 
    end
    cancel_on_return_answer = ask_func("Do you want to specify a return value for the function to terminate its repetition (y/n)? ", cancel_choice_validator)
    cancel_on_return = nil
    case cancel_on_return_answer do
    "y" -> 
      ask_func("Specify a return value to auto-cancel repetition (start the input with \":\" to create an atom): ", cancel_on_return_validator)
    "n" ->
      {:error, "not implemented"}
    {:error, "escaped input"} -> {:error, "escaped input"}
    end

  end

  defp ask_existing_name(query) do
    validator = fn(input) ->
      if (PeriodicalTimer.is_name_taken(MyPeriodicalTimer, input)) do 
        input 
      else 
        IO.puts "No process exists by that name!"
        false 
      end
    end
    ask_func(query, validator)
  end

  defp ask_interval() do
    validator = fn (input) -> try do String.to_integer(input) rescue _e -> false end end
    ask_func("Give an interval in milliseconds to repeat this task: ", validator)
  end

  defp ask_module() do
    is_function_validator = fn ([input_module, input_func, arg_arr]) -> 
      try do
        maybe_module = String.to_existing_atom("Elixir." <> input_module)
        maybe_func = String.to_existing_atom(input_func)
        Kernel.function_exported?(maybe_module, maybe_func, length(arg_arr)) &&
        [maybe_module, maybe_func, arg_arr] ||
        false
      rescue
        e -> false
      end
    end
    ask_until = fn(acc, func) ->
      answer = ask_func("Give a parameter or 'n' + return to finish (empty input is discarded): ")
      if answer == {:error, "escaped input"} do
        {:error, "escaped input"}
      else
        if answer != "n" do
          func.((answer != "" && acc ++ [answer] || acc), func)
        else  
          acc
        end 
      end
      
    end

    module = ask_func("Give a module name to execute: ")
    function_name = module != {:error, "escaped input"} && ask_func("Give a function name to execute from the module: ") || {:error, "escaped input"}
    params = function_name != {:error, "escaped input"} && ask_until.([], ask_until) || {:error, "escaped input"}

    # https://stackoverflow.com/questions/40007923/check-if-elixir-module-exports-a-specific-function
    # https://stackoverflow.com/questions/49360006/convert-module-name-to-string-and-back-to-module
    func_check = params != {:error, "escaped input"} && is_function_validator.([module, function_name, params]) || {:error, "escaped input"}

    case func_check do
      {:error, "escaped input"} -> {:error, "escaped input"}
      false ->
        IO.puts "No function and/or module exists with those definitions! Please input an existing module, function and the correct parameters for it to have!"
        IO.puts "For example... module: 'Ass8', function: 'test_func', parameters: (no parameters)"
        ask_module()
      _ ->
        func_check
    end
  end

    
  defp ask_for_a_function_to_execute do

      module_answer = ask_module()
      task_name = module_answer != {:error, "escaped input"} && ask_func("Give a name to refer this task to: ") || {:error, "escaped input"}
      interval = task_name != {:error, "escaped input"} && ask_interval() || {:error, "escaped input"}
      cancel_on_return =  interval != {:error, "escaped input"} && ask_cancel_on_return() || {:error, "escaped input"}
      
      cond do
        cancel_on_return == {:error, "escaped input"} ->
          {:error, "escaped input"}
        true ->
          [module_name, function_name, arr_of_args] = module_answer
          func = Function.capture(module_name, function_name, length(arr_of_args))
          [task_name, func, arr_of_args, interval, cancel_on_return]

      end
  end

  defp ask_reschedule do
    name = ask_existing_name("Input the name of a task you want to re-schedule: ")
    interval = name != {:error, "escaped input"} && ask_interval() || {:error, "escaped input"}
    name != {:error, "escaped input"} && interval != {:error, "escaped input"} && [name, interval] || {:error, "escaped input"}
  end

  defp test_func(val) do
    IO.puts "You found me and you gave me #{val} as an argument!"
  end

  defp ask_func(query, validator \\ nil) do
    input = IO.gets(query)
    result = String.trim_trailing(input, "\n")
    cond do
      validator && result != "e" ->
        if(validator.(result)) do
          validator.(result)
        else
          IO.puts "Wrong input!" 
          ask_func(query, validator)    
        end
      result == "e" ->
        {:error, "escaped input"}
      true ->
        result
    end

  end

  def ass8_mainloop() do
    import PeriodicalTimer
    import ProcessInfo
    {result, details} = PeriodicalTimer.start_link([])
    registry = result ==  :error && elem(details, 1) || details
    operation = ask_func("Please choose from following operations: 'list', 'schedule', 'reschedule', 'cancel', 'quit' or 'e' to escape back to menu during any operation: ", fn(input) -> Enum.find(["list", "schedule", "reschedule", "cancel", "quit"], fn op -> op == input end) end)
    operation = operation == {:error, "escaped input"} && :noop || operation
    case operation do
      "list" -> PeriodicalTimer.get_processes(MyPeriodicalTimer)

      "schedule" ->
        mod_details = ask_for_a_function_to_execute()
        cond do
          is_tuple(mod_details) && {:error, "escaped input"} == mod_details -> :ok
          true ->
            [task_name, task, task_args, interval, cancel_on_return] = mod_details
            # [task_name, task, task_args, interval, cancel_on_return] = ["test", &IO.puts/1, ["ok"], 4000, :noop] # debug
            function_was_scheduled = PeriodicalTimer.schedule_process(MyPeriodicalTimer, {%ProcessInfo{name: task_name, function: task, args: task_args}, interval, cancel_on_return})
            case function_was_scheduled do
              true -> IO.puts "Operation scheduled successfully!"
              false -> IO.puts "Error in scheduling a task (maybe a task of such name already exists?)"  
            end
        end
        
      "cancel" ->
        process_name = ask_existing_name("Input the name of a task you want to cancel: ")
        if (!is_tuple(process_name) || process_name != {:error, "escaped input"}) do
          PeriodicalTimer.cancel_process(MyPeriodicalTimer, process_name) && IO.puts "Task canceled succesfully!" || IO.puts "Something went wrong... try again!"
        end

      "reschedule" ->
        reschedule_details = ask_reschedule() 
        cond do
          is_tuple(reschedule_details) && {:error, "escaped input"} == reschedule_details-> :ok
          true ->
            [name, interval] = reschedule_details
            PeriodicalTimer.reschedule_process(MyPeriodicalTimer, name, interval)
        end
      :noop -> IO.puts "You already are in the main menu!"
      _ -> IO.puts "Quitting..."

    end
    if (operation != "quit") do ass8_mainloop() else :ok end
  end

end
