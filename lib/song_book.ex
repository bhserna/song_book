defmodule SongBook do
  defmodule State do
    defstruct [:config, :logged_in?]
  end

  defmodule SongRecord do
    defstruct [:id, :name, :body]
  end

  defmodule Validations do
    def validate_presence(data, key, message) do
      if Enum.member?(["", nil], Map.get(data, key)) do
        %{data | errors: [{key, message}|data.errors]}
      else
        data
      end
    end
  end

  defmodule Auth do
    def can?(:add_song, state) do
      !!state.logged_in?
    end

    def can?(:edit_song, state) do
      !!state.logged_in?
    end
  end

  defmodule Session do
    defmodule LoginForm do
      defstruct [:password]
    end

    def login_form do
      struct LoginForm
    end

    def login_with_password(config, state, password) do
      if Keyword.get(config, :password) == password do
        {:ok, %{state | logged_in?: true}}
      else
        {:error, "El password no es correcto"}
      end
    end

    def logout(state) do
      %{state | logged_in?: false}
    end
  end

  defmodule SongForm do
    import Validations
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

  defmodule ListOfSongs do
    defmodule CreateListForm do
      defstruct [:name, errors: []]
    end

    defmodule ListOfSongs do
      defstruct [:id, :name]
    end

    defmodule SongToListAssignment do
      defstruct [:list_id, :song_id]
    end

    def create_list_form do
      struct CreateListForm
    end

    def create_list(params, store) do
      import Validations

      form =
        create_list_form
        |> struct(name: params["name"])
        |> validate_presence(:name, "No puede estar en blanco")

      if Enum.empty?(form.errors) do
        {:ok, %{id: id}} =
          ListOfSongs
          |> struct(Map.from_struct(form))
          |> store.insert()

        {:ok, id}
      else
        {:error, form}
      end
    end

    def all_lists(store) do
      store.all |> Enum.sort_by(&(&1.id), &>=/2)
    end

    def add_song_to_list(list_id, song_id, store) do
      SongToListAssignment
      |> struct(list_id: list_id, song_id: song_id)
      |> store.insert()
    end
  end
end
