defmodule Assignment9 do
  use Application
  @moduledoc """
  Documentation for `Assignment9`.
  """

  @doc """
  
  ## Teacher's Instructions for Assignment 9:
    Copy the source code to Moodle return box. Alternatively you can paste a link to GitLab. If using GitLab, verify that you have added at least a Reporter permission for the lecturer.
    
    Use gen_tcp to implement message passing system with traditional client-server networking model.
    - Implement server process that listens and accepts new connections.
    - Implement client process that connects to the server and has interface to send a (text) message to the server.
    - When server receives the message from client, it echoes the message to all other connected clients.
    - Clients waits and shows messages from server.
    - Test your implementation with at least two clients.

    Bonus:
    - Allow client to assign a name to itself after its connected to the server.
    - When message is passed to other clients, show the name of the message originator.

  ## Examples

    For testing, please run all the commands used in the examples in different windows or tabs
    PS: This app also works with telnet! :)

    ## Example, server logs:
      user@localhost:~/M2296/elixir-programming/assignment_9$ iex -S mix
      Erlang/OTP 24 [erts-12.1.5] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

      Compiling 1 file (.ex)
      Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
      iex(1)> Assignment9.start_server
      {:ok, #PID<0.169.0>}
      iex(2)> 
      22:13:42.500 [info]  Accepting connections on port 5544
      
      22:14:27.599 [info]  Asking login details from an unnamed connection.
      
      22:14:32.397 [info]  tuukka has logged in.
      
      22:14:41.468 [info]  Asking login details from an unnamed connection.
      
      22:14:43.851 [info]  marko has logged in.
      
      22:14:51.757 [info]  tuukka: moro marko!
      
      22:15:11.669 [info]  marko: moi, mitä kuuluu? näkyy appsi toimivan :)
      
      22:15:39.495 [info]  tuukka: juu hyvin toimii, koodirivejä tuli tosin aika monta. Mulle kuuluu hyvää
      
      22:16:00.410 [info]  marko: hyvä kuulla. Ok, minun pitää mennä, moro!
      
      22:16:06.978 [info]  tuukka: moro!
      
      22:16:11.864 [info]  marko has logged out.
      
      22:16:16.909 [info]  tuukka has logged out.
 

    ## Example, user named "tuukka":
      user@localhost:~/M2296/elixir-programming/assignments$ iex -S mix
      Erlang/OTP 24 [erts-12.1.5] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

      Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
      iex(1)> Assignment9.ass9_mainloop
      Connection established. Type 'quit' to quit. 
      Tell me your name.
      tuukka
      tuukka has logged in.
      marko has logged in.
      moro marko!
      marko: moi, mitä kuuluu? näkyy appsi toimivan :)
      juu hyvin toimii, koodirivejä tuli tosin aika monta. Mulle kuuluu hyvää
      marko: hyvä kuulla. Ok, minun pitää mennä, moro!
      moro!
      marko has logged out.
      quit
      Terminating connection and exiting...
      :terminate
      iex(2)> 

    ## Example, user named "marko":
      user@localhost:~/M2296/elixir-programming/assignments$ iex -S mix
      Erlang/OTP 24 [erts-12.1.5] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit]

      Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
      iex(1)> Assignment9.ass9_mainloop
      Connection established. Type 'quit' to quit. 
      Tell me your name.
      marko
      marko has logged in.
      tuukka: moro marko!
      moi, mitä kuuluu? näkyy appsi toimivan :)
      tuukka: juu hyvin toimii, koodirivejä tuli tosin aika monta. Mulle kuuluu hyvää
      hyvä kuulla. Ok, minun pitää mennä, moro!
      tuukka: moro!
      quit
      Terminating connection and exiting...
      :terminate
      iex(2)>

  """


  def start_server do
    if Process.whereis(Ass9.Server) == nil do
      Ass9.Server.Supervisor.start_child(Ass9.Server, %{}, fn(pid) -> Ass9.Server.begin(pid) end)
    else
      "Process is already started"
    end
  end

  def ass9_mainloop(pid \\ nil) do
    if pid == nil do
      {result, details} = Ass9.Client.Supervisor.start_children()
      case {result, details} do
        {:ok, pid} ->
          IO.puts "Connection established. Type 'quit' to quit. "
          ass9_mainloop(pid)
        {:error, {:already_started, pid}} ->
          IO.puts "Connection established. Type 'quit' to quit. "
          ass9_mainloop(pid)
        {:error, reason} ->
          IO.puts "Failed to start client. Error: #{reason}"
          IO.puts "Exiting..."
      end
    else
      msg = IO.gets ""
      if msg == "quit\n" do
        IO.puts "Terminating connection and exiting..."
        Ass9.Client.terminate_connection(pid)
      else
        Ass9.Client.send_message(pid, msg)
        ass9_mainloop(pid)
      end

    end
    
  end
end
