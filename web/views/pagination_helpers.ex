defmodule Blog.PaginationHelpers do
  use Phoenix.HTML

  def render_pagination(_conn, %{total_pages: 1}), do: ""
  def render_pagination(conn, pagination) do
    content_tag(:nav, class: "pagination") do
      [
        previous_link(conn, pagination),
        next_link(conn, pagination),
        page_list(conn, pagination)
      ]
    end
  end

  def previous_link(_conn, %{page_number: 1}) do
    content_tag(:a, "Previous", class: "button is-disabled")
  end
  def previous_link(%{request_path: request_path}, %{page_number: page_number}) do
    link("Previous", to: build_url(request_path, page_number - 1), class: "button")
  end

  def next_link(_conn, %{page_number: page_number, total_pages: page_number}) do
    content_tag(:a, "Next", class: "button is-disabled")
  end
  def next_link(%{request_path: request_path}, %{page_number: page_number}) do
    link("Next", to: build_url(request_path, page_number + 1), class: "button")
  end

  def page_list(conn, %{total_pages: total_pages, page_number: page_number}) when total_pages <= 5 do
    content_tag(:ul) do
      page_range(1, total_pages, page_number, conn)
    end
  end
  def page_list(conn, %{total_pages: total_pages, page_number: page_number}) when page_number <= 3 do
    content_tag(:ul) do
      [
        page_range(1, 4, page_number, conn),
        page_list_spacer,
        page_list_link(conn, total_pages, page_number)
      ]
    end
  end
  def page_list(conn, %{total_pages: total_pages, page_number: page_number}) when total_pages - page_number <= 2 do
    content_tag(:ul) do
      [
        page_list_link(conn, 1, page_number),
        page_list_spacer,
        page_range(total_pages - 3, total_pages, page_number, conn)
      ]
    end
  end
  def page_list(conn, %{total_pages: total_pages, page_number: page_number}) do
    content_tag(:ul) do
      [
        page_list_link(conn, 1, page_number),
        page_list_spacer,
        page_range(page_number - 1, page_number + 1, page_number, conn),
        page_list_spacer,
        page_list_link(conn, total_pages, page_number)
      ]
    end
  end

  defp page_list_link(_conn, page, page) do
    content_tag(:li) do
      content_tag(:a, page, class: "button is-primary")
    end
  end
  defp page_list_link(%{request_path: request_path}, page, _page_number) do
    content_tag(:li) do
      link(page, to: build_url(request_path, page), class: "button")
    end
  end

  defp page_range(from, to, page_number, conn) do
    for page <- from..to do
      page_list_link(conn, page, page_number)
    end
  end

  def page_list_spacer do
    content_tag(:li) do
      content_tag(:span, "...")
    end
  end

  defp build_url(request_path, page_num) do
    "#{request_path}?page=#{page_num}"
  end
end
