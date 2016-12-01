defmodule Blog.PostView do
  use Blog.Web, :view

  def post_body(%{body: body}) do
    {:safe, body} = html_escape(body)
    {:safe, Earmark.to_html(body)}
  end
end
