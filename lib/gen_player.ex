defmodule GenPlayer do
  use GenServer

  # Public API

  def be_seated(player_name) do
    GenServer.start_link(__MODULE__, player_name, [])
  end

  def name(pid), do: GenServer.call(pid, :name)

  def stack(pid), do: GenServer.call(pid, :stack)

  def cards(pid), do: GenServer.call(pid, :cards)

  def buy_chips(pid, amount), do: GenServer.cast(pid, {:buy_chips, amount})

  def bet(pid, amount), do: GenServer.call(pid, {:bet, amount})

  def deal_cards(pid, card1, card2), do: GenServer.cast(pid, {:deal_cards, card1, card2})

  # Callbacks

  def init(player_name) do
    {:ok, %{name: player_name, stack: 0, cards: {nil, nil}}}
  end

  def handle_cast({:buy_chips, amount}, player) do
    {:noreply, adjust_stack(player, amount)}
  end

  def handle_cast({:deal_cards, card1, card2}, player) do
    {:noreply, update_cards(player, {card1, card2})}
  end

  def handle_call({:bet, amount}, _from, player) do
    player = adjust_stack(player, -amount)
    {:reply, {:ok, player[:stack]}, player}
  end

  def handle_call(:name,  _from, %{name:  name}  = player), do: {:reply, name,  player}

  def handle_call(:stack, _from, %{stack: stack} = player), do: {:reply, stack, player}

  def handle_call(:cards, _from, %{cards: cards} = player), do: {:reply, cards, player}

  # Helper functions

  defp update_cards(player, cards) do
    Map.put(player, :cards, cards)
  end

  defp adjust_stack(player, amount) do
    Map.update!(player, :stack, &(&1 + amount))
  end
end

