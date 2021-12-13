defmodule Ass9.Server.Connection do
  @enforce_keys [:name, :socket]
  defstruct [:name, :socket]
end

defmodule Ass9.Server.Storage do
  use GenServer

  # Client 

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def find(pid, name) do
    GenServer.call(pid, {:find, name})
  end

  def put(pid, conn) do
    GenServer.call(pid, {:put, conn})
  end
  
  def delete(pid, conn_name) do
    GenServer.cast(pid, {:del, conn_name})
  end

  # Server
  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def handle_call(:get, _from, connections) do
      {:reply, connections, connections}
  end

  @impl true
  def handle_call({:find, name}, _from, connections) do
      {:reply, Enum.find(connections, fn (conn) -> conn.name == name end), connections}
  end

  @impl true
  # sync so no race conditions are caused if you put and then instantly get the same item
  def handle_call({:put, conn}, _from, connections) do
      {:reply, :ok, connections ++ [conn]}
  end

  @impl true
  def handle_cast({:del, conn}, connections) do
      {:noreply, connections -- [conn]}
  end

  @impl true
  def handle_info(:terminate, connections) do
      {:stop, :normal, connections}
  end
end

defmodule Ass9.Server.ConnectionAgent do
  require Logger
  import Ass9.Server.Connection
  use GenServer, restart: :temporary

  defstruct [:name]

  defp connection_init(connection) do
    :gen_tcp.send(connection.socket, "Tell me your name.\n")
    Logger.info "Asking login details from an unnamed connection."
    name = read_line(connection)
    |> String.trim_trailing("\n")
    |> String.trim_trailing("\r")
    if (Enum.find_value(Ass9.Storage.get(Ass9.Server.Storage), fn %_{name: recipient_name, socket: socket} -> recipient_name == name end)) do
      :gen_tcp.send(connection.socket, "Someone with your name has already logged in. Multiple sessions are not allowed. Use a different name!\n")
      connection_init(connection)
    else
      Ass9.Server.Storage.delete(Ass9.Server.Storage, connection)
      Ass9.Server.Storage.put(Ass9.Server.Storage, %Ass9.Server.Connection{name: name, socket: connection.socket})
      write_line("#{name} has logged in.\n", connection, true)
      mainloop(%Ass9.Server.ConnectionAgent{name: name})
    end
  end

  def mainloop(state) do
    connection = Ass9.Server.Storage.find(Ass9.Server.Storage, state.name)
    if connection do
      answer = connection
      |> read_line()
      |> write_line(connection)

      unless answer == "TERMINATE CONNECTION" do
          mainloop(connection) 
      else
        send(self(), :terminate)
        Ass9.Server.Storage.delete(Ass9.Server.Storage, connection)
        Logger.info [connection.name |> to_string, " has logged out."]
        connection
      end 
    end
    
  end

  defp read_line(conn) do
    {status, data} = :gen_tcp.recv(conn.socket, 0)
    if status == :error do
      "terminate::sfzdvfbn fhcxzds\n"
    else
      data
    end
    
  end

  defp write_line(line, conn, log_in \\ false) do
    print = line == "terminate::sfzdvfbn fhcxzds\n" && "TERMINATE CONNECTION\n" || line |> to_string
    if print != "TERMINATE CONNECTION\n" do
      msg = !log_in &&  
      "#{conn.name}: " <> print || print
      Logger.info [msg |> String.trim_trailing("\n")]
      conns = log_in && Ass9.Server.Storage.get(Ass9.Server.Storage) || Ass9.Server.Storage.get(Ass9.Server.Storage) -- [conn]
      Enum.each(conns, fn saved_conn -> saved_conn.name != nil && :gen_tcp.send(saved_conn.socket, msg) end)
    else
      conns = Ass9.Server.Storage.get(Ass9.Server.Storage) -- [conn]
      Enum.each(conns, fn saved_conn -> saved_conn.name != nil && :gen_tcp.send(saved_conn.socket, "#{conn.name} has logged out.\n" |> to_charlist) end)
    end

    print 
    |> to_string 
    |> String.trim_trailing("\n")
    
  end

  # Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{socket: opts.client})
  end

  def begin(pid) do
    GenServer.cast(pid, :begin)
  end

  # Server
  @impl true
  def init(opts) do
    conn = %Ass9.Server.Connection{name: nil, socket: opts.socket}
    storage = Process.whereis(Ass9.Server.Storage)
    if storage == nil do
      {:stop, :normal, conn}
    else
      Ass9.Server.Storage.put(Ass9.Server.Storage, conn)
      {:ok, conn}
    end
  end

  defp end_connection(conn) do
    Ass9.Server.Storage.delete(Ass9.Server.Storage, conn.name)
    conn
  end

  @impl true
  def handle_call(:get, _from, connection) do
      {:reply, connection, connection}
  end
 
  @impl true
  def handle_cast(:begin, connection) do
      {:noreply, connection_init(connection)}
  end

  @impl true
  def handle_info(:terminate, connection) do
      {:stop, :normal, end_connection(connection)}
  end
end


defmodule Ass9.Server do
    require Logger
    use GenServer
    import Ass9.Server.Connection
    import Ass9.Server.ConnectionAgent
    import Ass9.Server.Storage
    defstruct [:socket, :storage]
  
    # Server backend functions
    def accept(state) do
      # The options below mean:
      #
      # 1. `:binary` - receives data as binaries (instead of lists)
      # 2. `packet: :line` - receives data line by line
      # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
      # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
      #
      port = 5544
      {:ok, socket} =
        :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
      Logger.info("Accepting connections on port #{port}")
      loop_acceptor(%Ass9.Server{socket: socket, storage: state.storage})
    end
  
    defp loop_acceptor(state) do
        {:ok, client} = :gen_tcp.accept(state.socket)
        
        {:ok, _pid} = Ass9.Server.Supervisor.start_child(Ass9.Server.ConnectionAgent, %{client: client}, fn(pid) -> Ass9.Server.ConnectionAgent.begin(pid) end)
        
        loop_acceptor(state)
    end
  
    defp read_line(socket) do
      {:ok, data} = :gen_tcp.recv(socket, 0)
      data
      |> to_string
      |> String.trim_trailing("\n")
      |> String.trim_trailing("\r")
      |> String.to_atom
    end

    # Client

    def start_link(default) do
      GenServer.start_link(__MODULE__, default, name: __MODULE__)
    end

    def begin(pid) do
      GenServer.cast(pid, :begin)
    end
    # Server callbacks

    @impl true
    def init(_opts) do
        storage = Process.whereis(Ass9.Server.Storage)
        {:ok, %Ass9.Server{storage: storage}}
        
    end

    @impl true
    def handle_cast(:begin, state) do
        {:noreply, accept(state)}
    end

end

defmodule Ass9.Server.MainSuperVisor do
  use Supervisor

  # Client 
  def start_link(opts) do
      Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # Server 
  @impl Supervisor
  def init(_init_arg) do
      children = [
          {Ass9.Server.Supervisor, %{}},
          {Ass9.Server.Storage, []}
        ]
      Supervisor.init(children, strategy: :rest_for_one)
  end
  
end

defmodule Ass9.Server.Supervisor do
  use DynamicSupervisor

  # Client 

  def start_link(opts) do
      DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def start_child(mod, args, func \\ nil) do

    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__,  {
        mod,
        args
    })

    func && func.(pid)
    {:ok, pid}
  end

  # Server 

  @impl DynamicSupervisor
  def init(_init_arg) do
      DynamicSupervisor.init(strategy: :one_for_one)
  end
  
end
  