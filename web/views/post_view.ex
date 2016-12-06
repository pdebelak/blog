defmodule Blog.PostView do
  use Blog.Web, :view

  def post_body(%{body: body}) do
    {:safe, body} = html_escape(body)
    {:safe, Earmark.to_html(body)}
  end

  def published(changeset) do
    !!Ecto.Changeset.get_field(changeset, :published_at) ||Ecto.Changeset.get_field(changeset, :published)
  end

  def comment_changeset(post) do
    Blog.Comment.changeset(%Blog.Comment{post_id: post.id})
  end

  def tag_value(%{data: %{ tags: %Ecto.Association.NotLoaded{}}}), do: ""
  def tag_value(%{data: %{ tags: tags}}) do
    tags
    |> Enum.map(fn tag -> tag.name end)
    |> Enum.join(", ")
  end
end
