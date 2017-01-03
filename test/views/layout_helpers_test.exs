defmodule Blog.LayoutHelpersTest do
  use Blog.ConnCase, async: true

  import Blog.LayoutHelpers

  test "signed_in when not signed in" do
    output = signed_in(%Plug.Conn{}) do
      "Some content!"
    end
    assert output == ""
  end

  test "signed_in when signed in" do
    output = signed_in(%Plug.Conn{assigns: %{user: %Blog.User{}}}) do
      "Some content!"
    end
    assert output == "Some content!"
  end
end
