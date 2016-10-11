defmodule SongBookWeb.SongController do
  use SongBookWeb.Web, :controller

  plug :scrub_params, "song" when action in [:create]

  def show(conn, %{"id" => id}) do
    song = SongBook.WatchSong.watch_song(SongBookWeb.Song, id)
    render conn, "show.html", song: song
  end

  def index(conn, _params) do
    songs = SongBook.WatchAllSongs.all_songs(SongBookWeb.Song)
    render conn, "index.html", songs: songs
  end

  def new(conn, _params) do
    form = SongBook.AddSong.add_song_form
    render conn, "new.html", form: form
  end

  def create(conn, %{"song" => %{"name" => name, "body" => body}}) do
    case SongBook.AddSong.add_song(SongBookWeb.Song, name, body) do
      {:ok, song_id} ->
        redirect conn, to: song_path(conn, :show, song_id)

      {:error, form} ->
        render conn, "new.html", form: form
    end
  end
end
