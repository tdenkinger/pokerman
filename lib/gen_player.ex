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

  def handle_cast({:deal_cards, card1, card2}, player) do
    noreply(update_cards(player, {card1, card2}))
  end

  def handle_cast({:buy_chips, amount}, player) do
    player |> adjust_stack(amount) |> noreply
  end

  def handle_call({:bet, amount}, _from, player) do
    player |> adjust_stack(-amount) |> reply_with(:stack)
  end

  def handle_call(:name,  _from, %{name:  name}  = player), do: reply(player, name)

  def handle_call(:stack, _from, %{stack: stack} = player), do: reply(player, stack)

  def handle_call(:cards, _from, %{cards: cards} = player), do: reply(player, cards)

  # Helper functions

  defp reply(state, return), do: {:reply, return, state}

  defp reply_with(state, atom), do: {:reply, {:ok, state[atom]}, state}

  defp noreply(state), do: {:noreply, state}

  defp update_cards(player, cards), do: Map.put(player, :cards, cards)

  defp adjust_stack(s = %{stack: chips}, amount), do: s |> Map.put(:stack, chips + amount)
end

