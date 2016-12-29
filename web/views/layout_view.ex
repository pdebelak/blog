defmodule Blog.LayoutView do
  use Blog.Web, :view

  def pages do
    Blog.Page
    |> Blog.Page.public()
    |> Blog.Repo.all()
  end

  def page_link(conn, page) do
    path = page_path(conn, :show, page)
    link page.title, to: path, class: page_link_class(conn, path)
  end

  defp page_link_class(%{request_path: request_path}, request_path), do: "nav-item is-active"
  defp page_link_class(_conn, _path), do: "nav-item"

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
