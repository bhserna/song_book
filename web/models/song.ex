defmodule SongBookWeb.Song do
  use SongBookWeb.Web, :model
  alias SongBookWeb.Repo

  @behaviour SongBook.AddSong.SongStore
  @behaviour SongBook.EditSong.SongStore
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

  def update(record) do
    __MODULE__
    |> Repo.get(record.id)
    |> changeset(Map.from_struct(record))
    |> Repo.update()
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, [:name, :body])
    |> validate_required([:name, :body])
  end

  def find(id) do
    __MODULE__
    |> Repo.get(id)
    |> to_song_record()
  end

  def find_all_by_name do
    __MODULE__
    |> order_by(:name)
    |> Repo.all()
    |> Enum.map(&to_song_record/1)
  end

  defp to_song_record(record) do
    attrs = record |> Map.from_struct()
    struct __MODULE__, attrs
  end
end
