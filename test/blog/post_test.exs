defmodule Blog.PostTest do
  use Blog.ModelCase

  alias Blog.Post

  @valid_attrs %{body: "Some content.", title: "The Title", description: "The description"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "sets the slug from the title" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert Ecto.Changeset.get_field(changeset, :slug) == "the-title"
  end

  test "publish sets the published_at" do
    changeset = Post.changeset(%Post{}, %{body: "Some content.", title: "The Title", publish: true})
    assert Ecto.Changeset.get_field(changeset, :published_at)
  end
end
