defmodule SongBookWeb.SongController do
  use SongBookWeb.Web, :controller

  plug :scrub_params, "song" when action in [:create, :update]

  def show(conn, %{"id" => id}) do
    song = SongBook.WatchSong.watch_song(store, id)
    render conn, "show.html", song: song
  end

  def index(conn, _params) do
    songs = SongBook.WatchAllSongs.all_songs(store)
    render conn, "index.html", songs: songs
  end

  def new(conn, _params) do
    form = SongBook.AddSong.add_song_form
    render conn, "new.html", form: form
  end

  def create(conn, %{"song" => %{"name" => name, "body" => body}}) do
    case SongBook.AddSong.add_song(store, name, body) do
      {:ok, song_id} ->
        redirect conn, to: song_path(conn, :show, song_id)

      {:error, form} ->
        render conn, "new.html", form: form
    end
  end

  def edit(conn, %{"id" => id}) do
    form = SongBook.EditSong.edit_song_form(store, id)
    render conn, "edit.html", song_id: id, form: form
  end

  def update(conn, %{"id" => id, "song" => %{"name" => name, "body" => body}}) do
    case SongBook.EditSong.update_song(store, id, name, body) do
      :ok ->
        redirect conn, to: song_path(conn, :show, id)

      {:error, form} ->
        render conn, "edit.html", song_id: id, form: form
    end
  end

  defp store do
    SongBookWeb.Song
  end
end
