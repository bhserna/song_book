defmodule AddSongTest do
  use ExUnit.Case
  doctest SongBook

  import SongBook.Auth, only: [can?: 2]

  defmodule StoreSpy do
    def insert(record) do
      send self, {__MODULE__, :insert, record}
      {:ok, record |> Map.put(:id, "1234")}
    end
  end

  @record_id "1234"

  test "is availabble for logged in users" do
    state = %SongBook.State{logged_in?: true}
    assert can?(:add_song, state)
  end

  test "is not availabble for not logged in users" do
    state = %SongBook.State{logged_in?: false}
    refute can?(:add_song, state)
  end

  test "it has a form with the name of the song" do
    form = add_song_form
    assert form.name == nil
  end

  test "it has a form with the body of the song" do
    form = add_song_form
    assert form.body == nil
  end

  test "it returns an error when there is no name" do
    {:error, errors} = add_song(nil, "Estas son...")
    assert errors == [name: "El nombre no puede estar en blanco"]
  end

  test "it returns an error when there is no description" do
    {:error, errors} = add_song("Las manañitas", nil)
    assert errors == [body: "La letra no puede estar en blanco"]
  end

  test "asks the store to create the song" do
    add_song("Las mañanitas", "Estas son...")
    assert_received {StoreSpy, :insert, %{name: "Las mañanitas", body: "Estas son..."}}
  end

  test "it returns the id of the created song" do
    {:ok, song_id} = add_song("Las mañanitas", "Estas son...")
    assert song_id == @record_id
  end

  def add_song_form do
    SongBook.AddSong.add_song_form
  end

  def add_song(name, body) do
    SongBook.AddSong.add_song(StoreSpy, name, body)
  end
end
