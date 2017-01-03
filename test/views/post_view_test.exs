defmodule Blog.PostViewTest do
  use Blog.ConnCase, async: true

  import Blog.PostView

  test "post body uses markdown" do
    {:safe, body} = post_body(%{body: "# Hello"})
    assert body == "<h1>Hello</h1>\n"
  end

  test "post body allows regular html" do
    {:safe, body} = post_body(%{body: "<p>Hello</p>"})
    assert body == "<p>Hello</p>"
  end

  test "post body with nil body returns empty string" do
    assert "" == post_body(%{body: nil})
  end

  test "published when post not published" do
    changeset = Blog.Post.changeset(%Blog.Post{})
    refute published(changeset)
  end

  test "published with a published_at" do
    changeset = Blog.Post.changeset(%Blog.Post{published_at: Ecto.DateTime.utc})
    assert published(changeset)
  end

  test "published with a publish field" do
    changeset = Blog.Post.changeset(%Blog.Post{}, %{"publish" => true})
    assert published(changeset)
  end

  test "comment_changeset connects to post" do
    post = %Blog.Post{id: 1}
    changeset = comment_changeset(post)
    assert Ecto.Changeset.get_field(changeset, :post_id) == post.id
  end

  test "tag_value with not loaded tags" do
    changeset = Blog.Post.changeset(%Blog.Post{})
    assert tag_value(changeset) == ""
  end

  test "tag_value with loaded tags" do
    changeset = Blog.Post.changeset(%Blog.Post{tags: [%Blog.Tag{name: "Tag1"}, %Blog.Tag{name: "Tag2"}]})
    assert tag_value(changeset) == "Tag1, Tag2"
  end
end
