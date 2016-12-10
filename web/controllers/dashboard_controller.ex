defmodule Blog.DashboardController do
  use Blog.Web, :controller

  alias Blog.{Post, CurrentUser}

  def index(conn, params) do
    page = Post
    |> where(user_id: ^CurrentUser.current_user(conn).id)
    |> Repo.paginate(params)
    render(conn, "index.html", posts: page.entries, pagination: page)
  end
end
