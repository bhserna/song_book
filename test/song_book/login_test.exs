defmodule LoginTest do
  use ExUnit.Case
  doctest SongBook

  @password "secret"
  @config [password: @password]
  @initial_state %SongBook.State{logged_in?: false}

  test "asks for the configured password" do
    form = login_form
    assert form.password == nil
  end

  test "returns success when the password match" do
    {status, _state} = login_with_password(@password)
    assert status == :ok
  end

  test "now the current user is logged in" do
    {:ok, state} = login_with_password(@password)
    assert state.logged_in?
  end

  test "does not returns success when the password does not match" do
    {status, _error} = login_with_password("other")
    assert status == :error
  end

  test "shows the error when password does not match" do
    {:error, error} = login_with_password("other")
    assert error == "El password no es correcto"
  end

  def login_form do
    SongBook.Login.login_form
  end

  def login_with_password(password) do
    SongBook.Login.login_with_password(@config, @initial_state, password)
  end
end
