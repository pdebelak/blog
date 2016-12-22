defmodule Blog.UserTest do
  use Blog.ModelCase

  alias Blog.{User, Fabricator}

  @valid_attrs %{"password" => "password!", "username" => "username"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(@valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(@invalid_attrs)
    refute changeset.valid?
  end

  test "it coerces usernames to lowercase" do
    user = Fabricator.create(:user, %{username: "Username"})
    {:error, _} = Fabricator.try_create(:user, %{username: "username"})
    assert user.username == "username"
  end

  test "it sets the hashed password" do
    changeset = User.changeset(@valid_attrs)
    assert changeset.changes.password_hash
  end

  test "authenticate with good password" do
    user = Fabricator.create(:user)
    {:ok, _} = User.authenticate(%{"username" => user.username, "password" => user.password})
  end

  test "authenticate with bad password" do
    Fabricator.create(:user)
    {:error, _} = User.authenticate(%{"username" => "username", "password" => "wrong"})
  end

  test "authenticate with bad username" do
    {:error, _} = User.authenticate(@valid_attrs)
  end
end
