defmodule Assignment9.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Ass9.Client.MainSuperVisor, name: Ass9.Client.MainSuperVisor, strategy: :one_for_one},
      {Ass9.Server.MainSuperVisor, name: Ass9.Server.MainSuperVisor, strategy: :one_for_one}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      strategy: :one_for_one, 
      name: Assignment9.Supervisor
    ]
    Supervisor.start_link(children, opts)
  end
end
