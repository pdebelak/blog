defmodule Blog.PaginationHelpersTest do
  use Blog.ConnCase, async: true

  import Blog.PaginationHelpers
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "previous_link when on first page" do
    link = previous_link(%Plug.Conn{}, %{page_number: 1}) |> safe_to_string()
    assert link == ~s(<a class="button is-disabled">Previous</a>)
  end

  test "previous_link when not on first page" do
    link = previous_link(%Plug.Conn{request_path: "/path"}, %{page_number: 2}) |> safe_to_string()
    assert link == ~s(<a class="button" href="/path?page=1">Previous</a>)
  end

  test "next_link when on last page" do
    link = next_link(%Plug.Conn{}, %{page_number: 2, total_pages: 2}) |> safe_to_string()
    assert link == ~s(<a class="button is-disabled">Next</a>)
  end

  test "next_link when not on last page" do
    link = next_link(%Plug.Conn{request_path: "/path"}, %{page_number: 2, total_pages: 3}) |> safe_to_string()
    assert link == ~s(<a class="button" href="/path?page=3">Next</a>)
  end

  test "page_list with few pages" do
    list = page_list(%Plug.Conn{request_path: "/path"}, %{total_pages: 2, page_number: 1}) |> safe_to_string()
    assert list == ~s(<ul><li><a class="button is-primary">1</a></li><li><a class="button" href="/path?page=2">2</a></li></ul>)
  end

  test "page_list with many pages on an early page" do
    list = page_list(%Plug.Conn{request_path: "/path"}, %{total_pages: 10, page_number: 3}) |> safe_to_string()
    assert list == ~s(<ul><li><a class="button" href="/path?page=1">1</a></li><li><a class="button" href="/path?page=2">2</a></li><li><a class="button is-primary">3</a></li><li><a class="button" href="/path?page=4">4</a></li><li><span>...</span></li><li><a class="button" href="/path?page=10">10</a></li></ul>)
  end

  test "page list with many pages on a later page" do
    list = page_list(%Plug.Conn{request_path: "/path"}, %{total_pages: 10, page_number: 8}) |> safe_to_string()
    assert list == ~s(<ul><li><a class="button" href="/path?page=1">1</a></li><li><span>...</span></li><li><a class="button" href="/path?page=7">7</a></li><li><a class="button is-primary">8</a></li><li><a class="button" href="/path?page=9">9</a></li><li><a class="button" href="/path?page=10">10</a></li></ul>)
  end

  test "page list with many pages in the middle" do
    list = page_list(%Plug.Conn{request_path: "/path"}, %{total_pages: 10, page_number: 5}) |> safe_to_string()
    assert list == ~s(<ul><li><a class="button" href="/path?page=1">1</a></li><li><span>...</span></li><li><a class="button" href="/path?page=4">4</a></li><li><a class="button is-primary">5</a></li><li><a class="button" href="/path?page=6">6</a></li><li><span>...</span></li><li><a class="button" href="/path?page=10">10</a></li></ul>)
  end

  test "render_pagination with one page" do
    pagination = render_pagination(%Plug.Conn{}, %{total_pages: 1})
    assert pagination == ""
  end

  test "render_pagination with more than one page" do
    pagination = render_pagination(%Plug.Conn{request_path: "/path"}, %{total_pages: 2, page_number: 1}) |> safe_to_string()
    assert pagination == ~s(<nav class="pagination"><a class="button is-disabled">Previous</a><a class="button" href="/path?page=2">Next</a><ul><li><a class="button is-primary">1</a></li><li><a class="button" href="/path?page=2">2</a></li></ul></nav>)
  end
end
