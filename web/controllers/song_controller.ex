defmodule SongBookWeb.SongController do
  use SongBookWeb.Web, :controller

  @song %{
    title: "Aire navideño",
    slug: "aire-navideño",
    body: """
Hay un aire navideño ALELUYA
Y los niños hacen bailes ALELUYA
Sus cantos brindan al recién nacido Rey
Amor y alegría nos vino a traer

Hey hey hey la la la la
Hey hey hey ALELUYA
Hey hey hey la la la la
Hey hey heh ALELUYA

Juntemos las manos ALELUYA
A su amor cantemos ALELUYA
Los niños felices bailan para el niño Rey
Amor y alegría nos vino a traer

Hey hey hey... 
    """
  }

  def show(conn, _params) do
    render conn, "show.html", song: @song
  end

  def new(conn, _params) do
    form = SongBook.AddSong.add_song_form
    render conn, "new.html", form: form
  end

  def create(conn, %{"song" => %{"name" => name, "body" => body}}) do
    case SongBook.AddSong.add_song(:fake, name, body) do
      {:ok, song_id} ->
        redirect conn, to: song_path(conn, :show, song_id)

      {:error, errors} ->
        form = SongBook.AddSong.add_song_form
        render conn, "new.html", form: form
    end
  end
end
