defmodule Blog.UpdatePostTest do
  use Blog.ConnCase, async: true

  alias Blog.{Post, Tag, Repo}
  import Blog.UpdatePost

  test "creates a post" do
    {:ok, post} = update_post(%Post{user_id: create_user.id}, %{"body" => "body", "title" => "title", "tags" => "Tag1, Tag2"})
    assert post.id
    assert post.title == "title"
    assert post.body == "body"
    assert post.tags |> Enum.map(fn tag -> tag.name end) == ["Tag1", "Tag2"]
  end

  test "uses existing tags if they exist" do
    tag = %Tag{name: "Tag1"} |> Repo.insert!()
    {:ok, post} = update_post(%Post{user_id: create_user.id}, %{"body" => "body", "title" => "title", "tags" => "Tag1"})
    post_tag = post.tags |> List.first
    assert post_tag.id == tag.id
  end

  test "both uses existing and creates new tags" do
    tag = %Tag{name: "Tag1"} |> Repo.insert!()
    {:ok, post} = update_post(%Post{user_id: create_user.id}, %{"body" => "body", "title" => "title", "tags" => "Tag1, Tag2"})
    first_tag = post.tags |> List.first
    assert first_tag.id == tag.id
    assert length(post.tags) == 2
  end

  test "removes tags from a post" do
    {:ok, post} = update_post(%Post{user_id: create_user.id}, %{"body" => "body", "title" => "title", "tags" => "Tag1, Tag2"})
    {:ok, post} = update_post(post, %{"body" => "body", "title" => "title", "tags" => "Tag2"})
    tags = post.tags
    assert length(tags) == 1
    assert List.first(tags).name == "Tag2"
  end

  defp create_user do
    Blog.User.changeset(%{ username: "username", password: "password" })
    |> Repo.insert!()
  end
end