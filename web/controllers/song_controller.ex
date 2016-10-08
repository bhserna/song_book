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
end
