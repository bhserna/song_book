defmodule SongBookWeb.Song do
  use SongBookWeb.Web, :model
  alias SongBookWeb.Repo

  @behaviour SongBook.AddSong.SongStore
  @behaviour SongBook.WatchSong.SongStore
  @behaviour SongBook.WatchAllSongs.SongStore

  schema "songs" do
    field :name, :string
    field :body, :string

    timestamps()
  end

  def insert(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, [:name, :body])
    |> validate_required([:name, :body])
  end

  def find(id) do
    Repo.get(__MODULE__, id)
  end

  def find_all_by_name do
    __MODULE__
    |> order_by(:name)
    |> Repo.all()
  end
end
