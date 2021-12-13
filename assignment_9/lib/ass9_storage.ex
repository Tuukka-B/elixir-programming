defmodule Ass9.Storage do
    use GenServer


    def start_link(name, init_opts) do
        GenServer.start_link(__MODULE__, init_opts, name: name)
    end
  
    def get(pid) do
        GenServer.call(pid, :get)
    end
  
    def put(pid, item, func) do
        GenServer.cast(pid, {:put, item, func})
    end
    
    def delete(pid, identifier, func) do
        GenServer.cast(pid, {:del, identifier, func})
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
    def handle_cast({:put, conn, func}, storage) do
        {:noreply, func.(storage, conn)}
    end
  
    @impl true
    def handle_cast({:del, identifier, func}, storage) do
        {:noreply, func.(storage, identifier)}
    end
  
    @impl true
    def handle_info(:terminate, storage) do
        {:stop, :normal, storage}
    end
  end