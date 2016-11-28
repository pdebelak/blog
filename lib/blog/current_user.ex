defmodule Blog.CurrentUser do
  def sign_in(conn, user) do
    conn
    |> Plug.Conn.put_session(:user_id, user.id)
    |> Plug.Conn.assign(:user, user)
  end

  def sign_out(conn) do
    conn
    |> Plug.Conn.delete_session(:user_id)
    |> Plug.Conn.assign(:user, nil)
  end

  def current_user(conn) do
    conn.assigns[:user]
  end

  def load_current_user(conn) do
    id = Plug.Conn.get_session(conn, :user_id)
    cond do
      id == nil -> conn
      user = Blog.Repo.get(Blog.User, id) -> sign_in(conn, user)
      true -> conn
    end
  end
end
