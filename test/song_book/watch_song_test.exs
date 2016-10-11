defmodule WatchSongTest do
  use ExUnit.Case
  doctest SongBook

  defmodule StoreStub do
    alias SongBook.SongRecord
    @behaviour SongBook.WatchSong.SongStore

    @records [
      %SongRecord{id: 1, name: "Las mañanitas", body: "Estas son..."},
      %SongRecord{id: 2, name: "Que detalle", body: "Que detalle..."},
      %SongRecord{id: 3, name: "Granito de mostaza", body: "Si pudiera ser..."}]

    def find(id) do
      @records |> Enum.find(& &1.id == id)
    end
  end

  test "the song has a name" do
    song = watch_song(1)
    assert song.name == "Las mañanitas"
  end

  test "the song has a body" do
    song = watch_song(3)
    assert song.body == "Si pudiera ser..."
  end

  def watch_song(id) do
    SongBook.WatchSong.watch_song(StoreStub, id)
  end
end
