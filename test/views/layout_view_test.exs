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

  test "pages has public pages" do
    public_page = Blog.Fabricator.create(:page)
    Blog.Fabricator.create(:page, %{public: false})
    assert length(pages) == 1
    assert List.first(pages).title == public_page.title
  end

  test "page_link when on that page" do
    link = page_link(%Plug.Conn{request_path: "/page/about"}, %Blog.Page{slug: "about"}) |> safe_to_string()
    assert String.match?(link, ~r/is-active/)
  end

  test "page_link when not on that page" do
    link = page_link(%Plug.Conn{request_path: "/other"}, %Blog.Page{slug: "about"}) |> safe_to_string()
    refute String.match?(link, ~r/is-active/)
  end
end
