defmodule AgentPlayer do
  def be_seated(name) do
    Agent.start_link(fn -> %{name: name, stack: 0, cards: {nil, nil}} end)
  end

  def name(player_pid), do: get_attribute(player_pid, :name)

  def stack(player_pid), do: get_attribute(player_pid, :stack)

  def cards(player_pid), do: get_attribute(player_pid, :cards)

  def buy_chips(player_pid, amount), do: adjust_stack(player_pid, amount)

  def bet(player_pid, amount), do: adjust_stack(player_pid, -amount)

  def deal_to(player_pid, card1, card2), do: update_cards(player_pid, {card1, card2})

  # Helper functions

  defp update_cards(player_pid, cards) do
    Agent.update(player_pid, fn(player) ->
      Map.put(player, :cards, cards )
    end)
  end

  defp adjust_stack(player_pid, amount) do
    Agent.update(player_pid, fn(player) ->
      Map.update!(player, :stack, &(&1 + amount))
    end)
    {:ok, AgentPlayer.stack(player_pid)}
  end

  defp get_attribute(player_pid, attr) do
    Agent.get(player_pid, fn(player) -> player[attr] end)
  end
end

