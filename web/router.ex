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

    get "/", PageController, :index
    get "/letras/:slug", SongController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", SongBookWeb do
  #   pipe_through :api
  # end
end
