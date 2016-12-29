defmodule Blog.PageTest do
  use Blog.ModelCase

  alias Blog.Page

  @valid_attrs %{body: "The body", description: "About it", title: "The title"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Page.changeset(%Page{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Page.changeset(%Page{}, @invalid_attrs)
    refute changeset.valid?
  end
end
