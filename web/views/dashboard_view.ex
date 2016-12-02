defmodule Blog.DashboardView do
  use Blog.Web, :view

  def smart_post_path(conn, post) do
    if post.published_at do
      post_path(conn, :show, post)
    else
      post_path(conn, :edit, post)
    end
  end
end
