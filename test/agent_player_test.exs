defmodule AgentPlayerTest do
  use ExUnit.Case, async: true
  doctest AgentPlayer

  setup do
    {:ok, player} = AgentPlayer.start_link("Troy")
    {:ok, player: player}
  end

  describe "GenPlayer" do
    test "has an initial state", %{player: player} do
      assert AgentPlayer.name(player)  == "Troy"
      assert AgentPlayer.stack(player) == 0
      assert AgentPlayer.cards(player) == {nil, nil}
    end

    test "can buy chips", %{player: player} do
      assert AgentPlayer.stack(player) == 0

      assert AgentPlayer.buy_chips(player, 100) == {:ok, 100}
      assert AgentPlayer.buy_chips(player, 500) == {:ok, 600}

      assert AgentPlayer.stack(player) == 600
    end

    test "can bet", %{player: player} do
      AgentPlayer.buy_chips(player, 150)
      assert AgentPlayer.bet(player, 50) == {:ok, 100}
    end

  #   test "can be dealt cards", %{player: player} do
  #     assert GenPlayer.cards(player) == {nil, nil}

  #     GenPlayer.deal_to(player, "5h", "5s")
  #     assert GenPlayer.cards(player) == {"5h", "5s"}

  #     GenPlayer.deal_to(player, "Ac", "Ad")
  #     assert GenPlayer.cards(player) == {"Ac", "Ad"}
  #   end
  end
end

