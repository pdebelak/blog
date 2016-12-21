defmodule Blog.TagTest do
  use Blog.ModelCase

  alias Blog.Tag

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "it sets the slug" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert Ecto.Changeset.get_field(changeset, :slug) == "some-content"
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
