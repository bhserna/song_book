defmodule SongBookWeb.Router do
  use SongBookWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SongBookWeb do
    pipe_through :browser # Use the default browser stack

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    post "/logout", SessionController, :destroy

    get "/", SongController, :index
    resources "/canciones", SongController, as: :song, except: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SongBookWeb do
  #   pipe_through :api
  # end
end
