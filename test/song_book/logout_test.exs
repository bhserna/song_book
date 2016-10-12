defmodule LogoutTest do
  use ExUnit.Case
  doctest SongBook

  @initial_state %SongBook.State{logged_in?: true}

  test "logs out the current user" do
    state = logout(@initial_state)
    refute state.logged_in?
  end

  def logout(state) do
    SongBook.Session.logout(state)
  end
end
