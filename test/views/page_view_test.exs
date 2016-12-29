defmodule Blog.PageViewTest do
  use Blog.ConnCase, async: true

  import Blog.PageView

  test "smart page path when public" do
    path = smart_page_path(%Plug.Conn{}, %Blog.Page{slug: "slug", public: true})
    assert path == "/page/slug"
  end

  test "smart page path when not public" do
    path = smart_page_path(%Plug.Conn{}, %Blog.Page{slug: "slug", public: false})
    assert path == "/admin/pages/slug/edit"
  end
end
