defmodule Blog.PageView do
  use Blog.Web, :view

  def smart_page_path(conn, page) do
    if page.public do
      page_path(conn, :show, page)
    else
      page_path(conn, :edit, page)
    end
  end
end
