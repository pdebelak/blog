defmodule Blog.LayoutView do
  use Blog.Web, :view

  def write_link(conn) do
    link "Write", to: dashboard_path(conn, :index), class: write_link_class(conn)
  end

  defp write_link_class(%{request_path: request_path}) do
    if String.match?(request_path, ~r{\A/admin}) do
      "nav-item is-active"
    else
      "nav-item"
    end
  end
end
