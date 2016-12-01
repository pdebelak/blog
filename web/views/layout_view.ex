defmodule Blog.LayoutView do
  use Blog.Web, :view

  def write_link(%{request_path: path} = conn) do
    class = if String.match?(path, ~r{\A/admin}) do
      "nav-item is-active"
    else
      "nav-item"
    end
    link "Write", to: dashboard_path(conn, :index), class: class
  end

  def signed_in?(conn), do: Blog.CurrentUser.current_user(conn)
end
