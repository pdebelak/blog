defmodule Blog.LayoutView do
  use Blog.Web, :view

  @title Application.get_env(:blog, :title)
  @description Application.get_env(:blog, :description)

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

  def title, do: @title
  def description, do: @description

  def title_for(%{assigns: %{post: post}}) do
    "#{post.title} | #{title}"
  end
  def title_for(%{assigns: %{page: page}}) do
    "#{page.title} | #{title}"
  end
  def title_for(_conn), do: title

  def description_for(%{assigns: %{post: post}}), do: post.description
  def description_for(%{assigns: %{page: page}}), do: page.description
  def description_for(_conn), do: description

  def og_meta_tags(conn=%{assigns: %{post: post}}) do
    [
      tag(:meta, property: "og:url", content: post_url(conn, :show, post)),
      tag(:meta, property: "og:type", content: "article"),
      tag(:meta, property: "og:title", content: post.title),
      tag(:meta, property: "og:description", content: post.description)
    ]
  end
  def og_meta_tags(conn=%{assigns: %{page: page}}) do
    [
      tag(:meta, property: "og:url", content: page_url(conn, :show, page)),
      tag(:meta, property: "og:title", content: page.title),
      tag(:meta, property: "og:description", content: page.description)
    ]
  end
  def og_meta_tags(conn) do
    [
      tag(:meta, property: "og:url", content: post_url(conn, :index)),
      tag(:meta, property: "og:title", content: title),
      tag(:meta, property: "og:description", content: description)
    ]
  end
end
