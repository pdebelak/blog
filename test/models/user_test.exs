defmodule Blog.UserTest do
  use Blog.ModelCase

  alias Blog.{User, Repo}

  @valid_attrs %{"password" => "password!", "username" => "username"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "it coerces usernames to lowercase" do
    user = User.changeset(%User{}, %{password: "password", username: "Username"}) |> Repo.insert!
    {:error, _} = User.changeset(%User{}, %{password: "password", username: "username"}) |> Repo.insert
    assert user.username == "username"
  end

  test "it sets the hashed password" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.changes.password_hash
  end

  test "authenticate with good password" do
    User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    {:ok, _} = User.authenticate(@valid_attrs)
  end

  test "authenticate with bad password" do
    User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    {:error, _} = User.authenticate(%{"username" => "username", "password" => "wrong"})
  end

  test "authenticate with bad username" do
    {:error, _} = User.authenticate(@valid_attrs)
  end
end
