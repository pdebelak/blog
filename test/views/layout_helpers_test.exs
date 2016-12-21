defmodule Blog.LayoutHelpersTest do
  use Blog.ConnCase, async: true

  import Blog.LayoutHelpers
  import Phoenix.HTML, only: [safe_to_string: 1]

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

  test "half_width" do
    half = half_width do
      "Content"
    end |> safe_to_string()
    assert half == ~s(<div class="columns"><div class="column">Content</div><div class="column"></div></div>)
  end
end
