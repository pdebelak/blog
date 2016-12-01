defmodule Blog.PostControllerTest do
  use Blog.ConnCase

  alias Blog.Post
  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing posts"
  end

  test "renders form for new resources", %{conn: conn} do
    user = create_user
    conn = conn
    |> with_current_user(user)
    |> get(post_path(conn, :new))
    assert html_response(conn, 200) =~ "New post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    user = create_user
    conn = conn
    |> with_current_user(user)
    |> post(post_path(conn, :create), post: @valid_attrs)
    assert redirected_to(conn) == post_path(conn, :index)
    assert Repo.get_by(Post, @valid_attrs).user_id == user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    user = create_user
    conn = conn
    |> with_current_user(user)
    |> post(post_path(conn, :create), post: @invalid_attrs)
    assert html_response(conn, 200) =~ "New post"
  end

  test "shows chosen resource", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = get conn, post_path(conn, :show, post)
    assert html_response(conn, 200) =~ "Show post"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user = create_user
    post = Repo.insert! %Post{user: user}
    conn = conn
    |> with_current_user(user)
    |> get(post_path(conn, :edit, post))
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = create_user
    post = Repo.insert! %Post{user: user}
    conn = conn
    |> with_current_user(user)
    |> put(post_path(conn, :update, post), post: @valid_attrs)
    assert redirected_to(conn) == post_path(conn, :show, post)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = create_user
    post = Repo.insert! %Post{user: user}
    conn = conn
    |> with_current_user(user)
    |> put(post_path(conn, :update, post), post: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "deletes chosen resource", %{conn: conn} do
    user = create_user
    post = Repo.insert! %Post{user: user}
    conn = conn
    |> with_current_user(user)
    |> delete(post_path(conn, :delete, post))
    assert redirected_to(conn) == post_path(conn, :index)
    refute Repo.get(Post, post.id)
  end

  defp create_user do
    Blog.User.changeset(%{ username: "username", password: "password" })
    |> Repo.insert!()
  end
end
