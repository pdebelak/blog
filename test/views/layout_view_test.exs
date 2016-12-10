defmodule Blog.LayoutViewTest do
  use Blog.ConnCase, async: true

  import Blog.LayoutView
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "write_link class when in admin" do
    link = write_link(%Plug.Conn{request_path: "/admin/posts/slug/edit"}) |> safe_to_string()
    assert String.match?(link, ~r/is-active/)
  end

  test "write_link class when not in admin" do
    link = write_link(%Plug.Conn{request_path: "/posts/slug"}) |> safe_to_string()
    refute String.match?(link, ~r/is-active/)
  end
end
