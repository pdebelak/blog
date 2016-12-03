defmodule Blog.CommentControllerTest do
  use Blog.ConnCase

  alias Blog.{Comment, Post}

  @valid_attrs %{name: "CommentCraft", body: "First!"}

  test "lists all entries on index", %{conn: conn} do
    {user, post} = create_post
    conn = conn
    |> with_current_user(user)
    |> get(post_comment_path(conn, :index, post))
    assert html_response(conn, 200)
  end

  test "creates a comment", %{conn: conn} do
    {_user, post} = create_post
    conn = post conn, post_comment_path(conn, :create, post, comment: @valid_attrs)
    assert redirected_to(conn) == post_path(conn, :show, post)
    assert Repo.get_by(Comment, @valid_attrs).post_id == post.id
  end

  test "deletes a comment", %{conn: conn} do
    {user, post} = create_post
    comment = Comment.changeset(%Comment{post: post}, @valid_attrs) |> Repo.insert!()
    conn = conn
    |> with_current_user(user)
    |> delete(comment_path(conn, :delete, comment))
    assert redirected_to(conn) == post_comment_path(conn, :index, post)
    refute Repo.get(Comment, comment.id)
  end

  defp create_post do
    user = Blog.User.changeset(%{ username: "username", password: "password" })
    |> Repo.insert!()
    post = Repo.insert! %Post{user: user, slug: "slug"}
    {user, post}
  end
end
