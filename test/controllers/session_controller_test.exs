defmodule Blog.SessionControllerTest do
  use Blog.ConnCase

  alias Blog.{User, Repo, CurrentUser}
  @valid_attrs %{password: "password", username: "username"}

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Sign in"
  end

  test "signs in and redirects when data is valid", %{conn: conn} do
    user = create_user
    conn = post conn, session_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == dashboard_path(conn, :index)
    assert CurrentUser.current_user(conn).id == user.id
  end

  test "does not sign in and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @valid_attrs
    assert html_response(conn, 200) =~ "Invalid username or password"
    refute CurrentUser.current_user(conn)
  end

  test "signs out", %{conn: conn} do
    user = create_user
    conn = conn
    |> with_current_user(user)
    |> delete(session_path(conn, :delete))
    assert redirected_to(conn) == post_path(conn, :index)
    refute CurrentUser.current_user(conn)
  end

  defp create_user do
    User.changeset(@valid_attrs) |> Repo.insert!
  end
end
