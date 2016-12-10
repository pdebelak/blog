defmodule Blog.DashboardViewTest do
  use Blog.ConnCase, async: true

  import Blog.DashboardView

  test "smart_post_path when not published" do
    post = %Blog.Post{slug: "slug"}
    conn = %Plug.Conn{}
    assert smart_post_path(conn, post) == post_path(conn, :edit, post)
  end

  test "smart_post_path when published" do
    post = %Blog.Post{slug: "slug", published_at: Ecto.DateTime.utc}
    conn = %Plug.Conn{}
    assert smart_post_path(conn, post) == post_path(conn, :show, post)
  end
end
