defmodule WatchAllSongsTest do
  use ExUnit.Case
  doctest SongBook

  defmodule StoreStub do
    alias SongBook.SongRecord
    @behaviour SongBook.WatchAllSongs.SongStore

    @records [
      %SongRecord{id: 1, name: "Las mañanitas", body: "Estas son..."},
      %SongRecord{id: 2, name: "Que detalle", body: "Que detalle..."},
      %SongRecord{id: 3, name: "Granito de mostaza", body: "Si pudiera ser..."}]

    def find_all_by_name do
      @records |> Enum.sort_by(& &1.name)
    end
  end

  test "each item has the id of the song" do
    ids = all_songs |> Enum.map(& &1.id) |> Enum.sort
    assert ids == [1, 2, 3]
  end

  test "the songs are ordered by name" do
    names = all_songs |> Enum.map(& &1.name)
    assert names == ["Granito de mostaza", "Las mañanitas", "Que detalle"]
  end

  def all_songs do
    SongBook.WatchAllSongs.all_songs(StoreStub)
  end
end
