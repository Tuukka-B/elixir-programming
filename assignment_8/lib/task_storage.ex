defmodule TaskStorage do
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
    def handle_call(:get, _from, storage) do
        {:reply, storage, storage}
    end
  
    @impl true
    def handle_call({:find, name}, _from, storage) do
        {:reply, Enum.find(storage, fn (item) -> item.details.name == name end), storage}
    end
  
    @impl true
    def handle_call({:put, task}, _from, storage) do
        {:reply, :ok, storage ++ [task]}
    end
  
    @impl true
    def handle_cast({:del, task}, storage) do
        {:noreply, storage -- [task]}
    end
  
    @impl true
    def handle_info(:terminate, storage) do
        {:stop, :normal, storage}
    end
  end