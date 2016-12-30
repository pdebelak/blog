defmodule Blog.PostView do
  use Blog.Web, :view

  def post_body(%{body: body}) do
    {:safe, body} = html_escape(body)
    {:safe, Earmark.to_html(body)}
  end

  def published(changeset) do
    !!Ecto.Changeset.get_field(changeset, :published_at) || Ecto.Changeset.get_field(changeset, :published)
  end

  def comment_changeset(post) do
    Blog.Comment.changeset(%Blog.Comment{post_id: post.id})
  end

  def tag_value(%{data: %{tags: %Ecto.Association.NotLoaded{}}}), do: ""
  def tag_value(%{data: %{tags: tags}}) do
    tags
    |> Enum.map(fn tag -> tag.name end)
    |> Enum.join(", ")
  end

  def changeset_map(changeset) do
    %{
      action: changeset.action,
      post: post_as_map(changeset),
      errors: changeset_errors(changeset)
    }
  end

  defp post_as_map(changeset = %{data: post}) do
    %{
      id: post.id,
      body: post.body,
      title: post.title,
      description: post.description,
      slug: post.slug,
      publish: published(changeset),
      tags: tag_value(changeset)
    }
  end

  defp changeset_errors(%{errors: errors}) do
    errors
    |> Enum.map(fn {field, {error, _}} -> {field, error} end)
    |> Enum.into(%{})
  end
end
