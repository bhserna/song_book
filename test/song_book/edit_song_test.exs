defmodule EditSongTest do
  use ExUnit.Case
  alias SongBook.SongRecord
  doctest SongBook

  import SongBook.Auth, only: [can?: 2]

  defmodule StoreFake do
    @behaviour SongBook.EditSong.SongStore

    def find(id) do
      %SongRecord{id: id, name: "Estas son...", body: "Las mañanitas"}
    end

    def update(record) do
      send self, {__MODULE__, :update, record}
      {:ok, record}
    end
  end

  @record_id "1234"

  test "is availabble for logged in users" do
    state = %SongBook.State{logged_in?: true}
    assert can?(:edit_song, state)
  end

  test "is not availabble for not logged in users" do
    state = %SongBook.State{logged_in?: false}
    refute can?(:add_song, state)
  end

  test "it has a form with the name of the song" do
    form = edit_song_form(@record_id)
    assert form.name == "Estas son..."
  end

  test "it has a form with the body of the song" do
    form = edit_song_form(@record_id)
    assert form.body == "Las mañanitas"
  end

  test "it returns an error when there is no name" do
    {:error, form} = update_song(@record_id, nil, "Estas son...")
    assert form.errors == [name: "El nombre no puede estar en blanco"]
    assert form.name == ""
    assert form.body == "Estas son..."
  end

  test "it returns an error when there is no description" do
    {:error, form} = update_song(@record_id, "Las manañitas", nil)
    assert form.errors == [body: "La letra no puede estar en blanco"]
    assert form.name == "Las manañitas"
    assert form.body == ""
  end

  test "asks the store to update the song" do
    update_song(@record_id, "Las mañanitas", "Estas son...")
    assert_received {StoreFake, :update, %SongRecord{id: @record_id, name: "Las mañanitas", body: "Estas son..."}}
  end

  test "it returns ok" do
    status = update_song(@record_id, "Las mañanitas", "Estas son...")
    assert status == :ok
  end

  def edit_song_form(id) do
    SongBook.EditSong.edit_song_form(StoreFake, id)
  end

  def update_song(id, name, body) do
    SongBook.EditSong.update_song(StoreFake, id, name, body)
  end
end
