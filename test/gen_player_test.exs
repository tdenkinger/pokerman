defmodule GenPlayerTest do
  use ExUnit.Case, async: true
  doctest GenPlayer

  setup do
    {:ok, player} = GenPlayer.start_link("Troy")
    {:ok, player: player}
  end

  describe "GenPlayer" do
    test "has an initial state", %{player: player} do
      assert GenPlayer.name(player)  == "Troy"
      assert GenPlayer.stack(player) == 0
      assert GenPlayer.cards(player) == {nil, nil}
    end

    test "can buy chips", %{player: player} do
      assert GenPlayer.stack(player) == 0

      GenPlayer.buy_chips(player, 100)
      assert GenPlayer.stack(player) == 100

      GenPlayer.buy_chips(player, 500)
      assert GenPlayer.stack(player) == 600
    end

    test "can bet", %{player: player} do
      GenPlayer.buy_chips(player, 150)
      assert GenPlayer.bet(player, 50) == {:ok, 100}
    end

    test "can be dealt cards", %{player: player} do
      assert GenPlayer.cards(player) == {nil, nil}

      GenPlayer.deal_to(player, "5h", "5s")
      assert GenPlayer.cards(player) == {"5h", "5s"}

      GenPlayer.deal_to(player, "Ac", "Ad")
      assert GenPlayer.cards(player) == {"Ac", "Ad"}
    end
  end
end

