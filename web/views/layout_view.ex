defmodule Blog.LayoutView do
  use Blog.Web, :view

  def signed_in?(conn), do: Blog.CurrentUser.current_user(conn)
end
