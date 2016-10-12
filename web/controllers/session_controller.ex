defmodule SongBookWeb.SessionController do
  use SongBookWeb.Web, :controller

  @config [password: "1234secret"]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"login" => %{"password" => password}}) do
    case SongBook.Session.login_with_password(@config, current_state(conn), password) do
      {:ok, state} ->
        conn
        |> update_state(state)
        |> put_flash(:info, "Has iniciado sesión exitosamente")
        |> redirect(to: "/")

      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: session_path(conn, :new))
    end
  end

  def destroy(conn, _params) do
    state = SongBook.Session.logout(current_state(conn))

    conn
    |> update_state(state)
    |> put_flash(:info, "Has terminado sesión exitosamente")
    |> redirect(to: "/")
  end
end
