defmodule GenPlayer do
  use GenServer

  # Public API

  def be_seated(player_name) do
    GenServer.start_link(__MODULE__, player_name, [])
  end

  def name(pid), do: GenServer.call(pid, {:name})

  def stack(pid), do: GenServer.call(pid, {:stack})

  def cards(pid), do: GenServer.call(pid, {:cards})

  def buy_chips(pid, amount), do: GenServer.cast(pid, {:add_chips, amount})

  def bet(pid, amount), do: GenServer.call(pid, {:bet, amount})

  def deal_to(pid, card1, card2), do: GenServer.cast(pid, {:deal_cards, card1, card2})

  # Callbacks

  def init(player_name) do
    {:ok, %{name: player_name, stack: 0, cards: {nil, nil}}}
  end

  def handle_cast({:add_chips, amount}, player_details) do
    {:noreply, adjust_stack(player_details, amount)}
  end

  def handle_cast({:deal_cards, card1, card2}, player_details) do
    {:noreply, update_cards(player_details, {card1, card2})}
  end

  def handle_call({:bet, amount}, _from, player_details) do
    player_details  = adjust_stack(player_details, -amount)
    {:reply, {:ok, player_details[:stack]}, player_details}
  end

  def handle_call({:name}, _from, player_details) do
    {:reply, player_details[:name], player_details}
  end

  def handle_call({:stack}, _from, player_details) do
    {:reply, player_details[:stack], player_details}
  end

  def handle_call({:cards}, _from, player_details) do
    {:reply, player_details[:cards], player_details}
  end

  # Helper functions
  defp update_cards(player_details, cards) do
    Map.put(player_details, :cards, cards)
  end

  defp adjust_stack(player, amount) do
    Map.update!(player, :stack, &(&1 + amount))
  end
end

