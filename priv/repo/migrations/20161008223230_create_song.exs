defmodule SongBookWeb.Repo.Migrations.CreateSong do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :name, :string
      add :body, :text

      timestamps()
    end

  end
end
