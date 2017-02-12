defmodule CreateListOfSongsTest do
  use ExUnit.Case
  doctest SongBook

  defmodule ListOfSongsStoreFake do
    def insert(list) do
      send self, {__MODULE__, :insert, list}
      {:ok, %{list | id: "given-id-1234"}}
    end
  end

  def create_list_form do
    SongBook.ListOfSongs.create_list_form
  end

  def create_list(params, store \\ ListOfSongsStoreFake) do
    SongBook.ListOfSongs.create_list(params, store)
  end

  def all_lists_of_songs(store) do
    SongBook.ListOfSongs.all_lists(store)
  end

  test "form to create new list has a name field" do
    form = create_list_form
    assert form.name == nil
  end

  describe "create list with name" do
    test "returns ok" do
      {status, _} = create_list(%{"name" => "Mi lista"})
      assert status == :ok
    end

    test "creates a new record in the store" do
      create_list(%{"name" => "Mi lista"})
      assert_received {ListOfSongsStoreFake, :insert, %{name: "Mi lista"}}
    end

    test "returns the id of the created list" do
      {:ok, list_id} = create_list(%{"name" => "Mi lista"})
      assert list_id == "given-id-1234"
    end
  end

  describe "create list without name" do
    test "returns a blank error" do
      {:error, form} = create_list(%{"name" => nil})
      assert form.errors[:name] == "No puede estar en blanco"
    end

    test "does not inserts a new record in the store" do
      create_list(%{"name" => nil})
      refute_received {ListOfSongsStoreFake, :insert, _}
    end
  end

  describe "show all of list of songs" do
    defmodule PrepopulatesListOfSongsStoreStub do
      def all, do: [
        %{id: 1, name: "Lista 1"},
        %{id: 2, name: "Lista 2"},
        %{id: 3, name: "Lista 3"}]
    end

    test "returns a list with all the lists of songs ordered descendent by id" do
      [list_three, list_two, list_one] = all_lists_of_songs(PrepopulatesListOfSongsStoreStub)
      assert list_three.name == "Lista 3"
      assert list_two.name == "Lista 2"
      assert list_one.name == "Lista 1"
    end
  end
end
