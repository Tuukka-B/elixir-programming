defmodule Ass9.Client.Connection do
    defstruct [:socket]
end

# I tried to make an all-purpose backend (in Ass9.Storage module) for both Client and Server's storage needs
# but ended up not implementing it for the Server, because I think the way it is done
# here is worse than how it is done in the Ass9.Server's side
# but I let it be here, as I'm running out of time and everything works perfectly anyways
defmodule Ass9.Storage.Client do
    import Ass9.Storage
    use GenServer

    # Client funcs, backend is imported from Ass9.Storage
    def start_link(opts) do
        Ass9.Storage.start_link(opts.name, opts.defaults)
    end
  
    def get(pid) do
        Ass9.Storage.get(pid)
    end
  
    def put(pid, conn) do
        # overwrites the previous state
        put_func = fn (state, new_item) -> %Ass9.Client.Connection{socket: new_item.socket} end
        Ass9.Storage.put(pid, conn, put_func)
    end
    
    def delete(pid, identifier \\ nil) do
        delete_func = fn (state, _identifier) -> %Ass9.Client.Connection{} end
        Ass9.Storage.delete(pid, identifier, delete_func)
    end
end

defmodule Ass9.Client.ConnectionAgent do
    use GenServer, restart: :temporary

    defstruct [:storage_worker]

    def mainloop(storage) do
        connection = Ass9.Storage.Client.get(storage.storage_worker)
        if connection.socket == nil do
            Ass9.Storage.Client.delete(storage.storage_worker)
            send(self(), :terminate)
            storage
        else
            result = connection
            |> read_line(storage)
            |> to_string
            |> String.trim_trailing("\n")
            |> print_line(connection)
            if result == true do
                mainloop(storage)
            else
                Ass9.Storage.Client.delete(storage.storage_worker)
                storage
            end
        end
        
    end
  
    defp read_line(conn, storage) do
        {status, reason} = :gen_tcp.recv(conn.socket, 0)
        if ({status, reason} == {:error, reason}) do
            "Connection closed.\n"
        else
            connection = Ass9.Storage.Client.get(storage.storage_worker).socket && reason || "Connection closed.\n"
        end
        
    end

    defp print_line(line, conn) do
        line = line |> to_string
        cond do
            line == "Connection closed." ->
                false
            line == "" ->
                true
            true ->
                IO.puts line 
                true
        end
        
    end
  
    # Client
    def start_link(opts) do
        GenServer.start_link(__MODULE__, opts.defaults)
    end

    def begin(pid) do
        GenServer.cast(pid, :begin)
    end

    def restart(pid, new_state) do
        GenServer.cast(pid, {:restart, new_state})
    end

    # Server
    @impl true
    def init(opts) do
        pid = %Ass9.Client.ConnectionAgent{storage_worker: opts.storage_worker}
        {:ok, pid}
    end

    @impl true
    def handle_call(:get, _from, connections) do
        {:reply, connections, connections}
    end

    @impl true
    def handle_cast(:begin, connection) do
        {:noreply, mainloop(connection)}
    end

    @impl true
    def handle_cast({:restart, new_conn}, _connection) do
        {:noreply, mainloop(new_conn)}
    end

    @impl true
    def handle_info(:terminate, connection) do
        {:stop, :normal, connection}
    end
  end

defmodule Ass9.Client do
    require Logger
    use GenServer

    # test function
    def connect_to_server_test() do
        {host, port} = {'127.0.0.1', 5544}
        {:ok, sock} = :gen_tcp.connect(host, port, [:binary, packet: :line, active: false])
        :ok = :gen_tcp.send(sock, to_charlist("hello\n"))
        {status, answer} = :gen_tcp.recv(sock, 0)
        IO.puts ["Server answered ", answer |> to_string |> String.trim_trailing("\n")]
        end_connection(sock)
        :ok = :gen_tcp.close(sock)
    end

    # Client
    def start_link(opts) do
        GenServer.start_link(__MODULE__, opts)
    end

    def send_message(pid, msg) do
        GenServer.cast(pid, {:send, msg})
    end
    

    def terminate_connection(pid) do
        send(pid, :terminate)
        
    end

    # Server internal functions

    defp end_connection(storage) do
        conn = Ass9.Storage.Client.get(storage.storage_worker).socket
        if conn != nil do
            :ok = :gen_tcp.send(conn,'terminate::sfzdvfbn fhcxzds\n')
            Ass9.Storage.Client.delete(storage.storage_worker)
        end
        storage
    end

    defp send_to_server(storage, msg) do
        # below conversion to allow 'åäö' and such characters, wouldn't work otherwise
        # https://stackoverflow.com/questions/51632851/converting-utf-8-iso-8859-bytes-string-to-charlist
        conn = Ass9.Storage.Client.get(storage.storage_worker).socket
        if conn != nil do
            msg = :unicode.characters_to_binary(
            String.to_charlist(msg), :latin1, :utf8
          )
            :ok = :gen_tcp.send(conn, msg)
        end
        storage
    end

    # Server
    @impl true
    def init(opts) do
        {:ok, opts}
    end
  
    @impl true
    def handle_cast({:send, msg}, storage) do
        {:noreply, send_to_server(storage, msg)}
    end

    @impl true
    def handle_info(:terminate, storage) do
        {:stop, :normal, end_connection(storage)}
    end
end

defmodule Ass9.Client.MainSuperVisor do
    use Supervisor

    # Client 
    def start_link(init_arg) do
        Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
    end

    # Server 
    @impl Supervisor
    def init(_init_arg) do
        children = [
            {Ass9.Client.Supervisor, [nil]},
            {Ass9.Storage.Client, %{name: Ass9.Storage.Client, defaults: %{}}}
          ]
        Supervisor.init(children, strategy: :rest_for_one)
    end
    
end

defmodule Ass9.Client.Supervisor do
    use DynamicSupervisor

    # Client 
    def start_link(init_arg) do
        DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
    end

    def start_children() do
        {host, port} = {'127.0.0.1', 5544}
        {outcome, sock} = :gen_tcp.connect(host, port, [:binary, packet: :line, active: false])
        storage = Process.whereis(Ass9.Storage.Client)
        if outcome == :error && !storage do
            IO.puts "Client encountered an error and has exited."
            {:error, sock}
        else
            
            Ass9.Storage.Client.put(storage, %Ass9.Client.Connection{socket: sock})

            # client interface to send messages with
            {:ok, client} = DynamicSupervisor.start_child(__MODULE__, {
                Ass9.Client, 
                %Ass9.Client.ConnectionAgent{storage_worker: storage}}
                )

            # client agent, which receives messages from
            {:ok, pid} = DynamicSupervisor.start_child(__MODULE__,  {
                Ass9.Client.ConnectionAgent,
                %{
                    defaults: %Ass9.Client.ConnectionAgent{storage_worker: storage}}
                })

            Ass9.Client.ConnectionAgent.begin(pid)
            {:ok, client}
        end  
    end

    # Server 
    @impl DynamicSupervisor
    def init(_init_arg) do
        DynamicSupervisor.init(strategy: :one_for_one)
    end
    
end