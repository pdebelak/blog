defmodule Blog.SessionController do
  use Blog.Web, :controller

  alias Blog.{User, CurrentUser}

  def new(conn, _params) do
    changeset = User.changeset
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => session_params}) do
    case User.authenticate(session_params) do
      {:ok, user} ->
        conn
        |> CurrentUser.sign_in(user)
        |> put_flash(:info, "Logged in!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid username or password.")
        |> render("new.html", changeset: %{changeset | action: :authenticate})
    end
  end

  def delete(conn, _params) do
    conn
    |> CurrentUser.sign_out()
    |> put_flash(:info, "Logged out!")
    |> redirect(to: page_path(conn, :index))
  end
end
