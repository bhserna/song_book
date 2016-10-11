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

    def can?(:edit_song, state) do
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

  defmodule SongForm do
    defstruct [name: "", body: "", errors: []]

    def with(name, body) do
      %SongForm{name: name || "", body: body || ""} |> validate()
    end

    def from_record(record) do
      struct __MODULE__, Map.from_struct(record)
    end

    defp validate(form) do
      form
      |> validate_presence(:name, "El nombre no puede estar en blanco")
      |> validate_presence(:body, "La letra no puede estar en blanco")
    end

    defp validate_presence(form, key, message) do
      if Map.get(form, key) == "" do
        %{form | errors: [{key, message}|form.errors]}
      else
        form
      end
    end
  end

  defmodule AddSong do
    defmodule SongStore do
      @callback insert(record :: map()) :: {atom(), any()}
    end

    def add_song_form do
      struct SongForm
    end

    def add_song(store, name, body) do
      form = SongForm.with(name, body)

      if Enum.empty?(form.errors) do
        {:ok, %{id: id}} = store.insert(%{name: name, body: body})
        {:ok, id}
      else
        {:error, form}
      end
    end
  end

  defmodule EditSong do
    defmodule SongStore do
      @callback find(id :: integer() | String.t) :: %SongRecord{}
      @callback update(record :: map()) :: {atom(), any()}
    end

    def edit_song_form(store, id) do
      store.find(id) |> SongForm.from_record()
    end

    def update_song(store, id, name, body) do
      form = SongForm.with(name, body)

      if Enum.empty?(form.errors) do
        record = store.find(id)
        {:ok, _} = store.update(%{record | name: name, body: body})
        :ok
      else
        {:error, form}
      end
    end
  end

  defmodule WatchAllSongs do
    defmodule SongStore do
      @callback find_all_by_name() :: [%SongRecord{}]
    end

    def all_songs(store) do
      store.find_all_by_name
    end
  end

  defmodule WatchSong do
    defmodule SongStore do
      @callback find(id :: integer() | String.t) :: %SongRecord{}
    end

    def watch_song(store, id) do
      store.find(id)
    end
  end
end
