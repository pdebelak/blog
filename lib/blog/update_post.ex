defmodule Blog.UpdatePost do
  alias Blog.{Post, Tag, Repo}
  import Ecto.Query

  def preview_post(post, post_params) do
    post_changeset(post, post_params)
    |> Ecto.Changeset.apply_changes()
  end

  def update_post(post, post_params) do
    post_changeset(post, post_params)
    |> Repo.insert_or_update()
  end

  defp post_changeset(post, post_params) do
    post
    |> Post.changeset(post_params)
    |> Ecto.Changeset.put_assoc(:tags, tags_from(post_params))
  end

  defp tags_from(%{"tags" => ""}), do: []
  defp tags_from(%{"tags" => tags}) do
    tags
    |> split_tags()
    |> find_tags()
    |> add_new_tags()
  end
  defp tags_from(_), do: []

  defp find_tags(tags) do
    query = from t in Tag, where: t.name in ^tags
    {Repo.all(query), tags}
  end

  defp add_new_tags({found_tags, tags}) do
    Enum.map(tags, fn tag ->
      if found = Enum.find(found_tags, fn found_tag -> found_tag.name == tag end) do
        found
      else
        Tag.changeset(%Tag{}, %{"name" => tag})
      end
    end)
  end

  defp split_tags(tags) do
    String.split(tags, ",") |> Enum.map(&String.trim/1)
  end
end
