defmodule Blog.PostControllerTest do
  use Blog.ConnCase

  alias Blog.{Post, Fabricator}
  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{body: "", title: ""}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200)
  end

  test "renders form for new resources", %{conn: conn} do
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> get(post_path(conn, :new))
    assert html_response(conn, 200) =~ "Write post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> post(post_path(conn, :create), post: @valid_attrs)
    assert String.match?(redirected_to(conn), ~r{/posts/})
    assert Repo.get_by(Post, @valid_attrs).user_id == user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> post(post_path(conn, :create), post: @invalid_attrs)
    assert html_response(conn, 200) =~ "Write post"
  end

  test "shows chosen resource", %{conn: conn} do
    post = Fabricator.create(:post)
    conn = get conn, post_path(conn, :show, post)
    assert html_response(conn, 200) =~ post.title
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    post = Fabricator.create(:post)
    conn = conn
    |> with_current_user(post.user)
    |> get(post_path(conn, :edit, post))
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    post = Fabricator.create(:post, %{publish: false})
    conn = conn
    |> with_current_user(post.user)
    |> put(post_path(conn, :update, post), post: @valid_attrs)
    assert redirected_to(conn) == post_path(conn, :edit, post)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post = Fabricator.create(:post)
    conn = conn
    |> with_current_user(post.user)
    |> put(post_path(conn, :update, post), post: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "deletes chosen resource", %{conn: conn} do
    post = Fabricator.create(:post)
    conn = conn
    |> with_current_user(post.user)
    |> delete(post_path(conn, :delete, post))
    assert redirected_to(conn) == post_path(conn, :index)
    refute Repo.get(Post, post.id)
  end
end
