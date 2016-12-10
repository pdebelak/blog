defmodule Blog.CommentControllerTest do
  use Blog.ConnCase

  alias Blog.{Comment, Fabricator}

  @valid_attrs %{name: "CommentCraft", body: "First!"}

  test "lists all entries on index", %{conn: conn} do
    post = Fabricator.create(:post)
    conn = conn
    |> with_current_user(post.user)
    |> get(post_comment_path(conn, :index, post))
    assert html_response(conn, 200)
  end

  test "creates a comment", %{conn: conn} do
    post = Fabricator.create(:post)
    conn = post conn, post_comment_path(conn, :create, post, comment: @valid_attrs)
    assert redirected_to(conn) == post_path(conn, :show, post)
    assert Repo.get_by(Comment, @valid_attrs).post_id == post.id
  end

  test "deletes a comment", %{conn: conn} do
    post = Fabricator.create(:post)
    comment = Fabricator.create(:comment, %{post: post})
    conn = conn
    |> with_current_user(post.user)
    |> delete(comment_path(conn, :delete, comment))
    assert redirected_to(conn) == post_comment_path(conn, :index, post)
    refute Repo.get(Comment, comment.id)
  end
end
