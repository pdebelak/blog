defmodule Blog.DashboardController do
  use Blog.Web, :controller

  alias Blog.{Post, CurrentUser}

  def index(conn, _params) do
    posts = Post
    |> where(user_id: ^CurrentUser.current_user(conn).id)
    |> Repo.all
    render(conn, "index.html", posts: posts)
  end
end
