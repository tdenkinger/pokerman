defmodule GenPlayer do
  use GenServer

  # Public API

  def start_link(player_name) do
    GenServer.start_link(__MODULE__, player_name, name: Player)
  end

  def name(pid) do
    GenServer.call(pid, {:name})
  end

  # Callbacks

  def init(player_name) do
    {:ok, %{name: player_name}}
  end

  def handle_call({:name}, _from, player_details) do
    {:reply, player_details[:name], player_details}
  end


end

