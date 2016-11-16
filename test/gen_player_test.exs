defmodule GenPlayerTest do
  use ExUnit.Case, async: true
  doctest GenPlayer

  setup do
    {:ok, player} = GenPlayer.start_link("Troy")
    {:ok, player: player}
  end

  test "stores a player's name", %{player: player} do
    assert GenPlayer.name(player) == "Troy"
  end
end

