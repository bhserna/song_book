defmodule SongBook do
  defmodule State do
    defstruct [:config, :logged_in?]
  end

  defmodule SongRecord do
    defstruct [:id, :name, :body]
  end

  defmodule Auth do
    def can?(:add_song, state) do
      !!state.logged_in?
    end
  end

  defmodule Login do
    defmodule Form do
      defstruct [:password]
    end

    def login_form do
      struct Form
    end

    def login_with_password(config, state, password) do
      if Keyword.get(config, :password) == password do
        {:ok, %{state | logged_in?: true}}
      else
        {:error, "El password no es correcto"}
      end
    end
  end

  defmodule AddSong do
    defmodule Form do
      defstruct [:name, :body]
    end

    def add_song_form do
      struct Form
    end

    def add_song(store, name, body) do
      errors = validate(name, body)

      if Enum.empty?(errors) do
        {:ok, %{id: id}} = store.insert(%{name: name, body: body})
        {:ok, id}
      else
        {:error, errors}
      end
    end

    defp validate(name, body) do
      []
      |> validate_presence(name, :name, "El nombre no puede estar en blanco")
      |> validate_presence(body, :body, "La letra no puede estar en blanco")
    end

    defp validate_presence(errors, value, key, message) do
      if value, do: errors, else: [{key, message}|errors]
    end
  end

  defmodule WatchAllSongs do
    def all_songs(store) do
      store.find_all_by_name
    end
  end

  defmodule WatchSong do
    def watch_song(store, id) do
      store.find(id)
    end
  end
end
