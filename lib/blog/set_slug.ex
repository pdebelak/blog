defmodule Blog.SetSlug do
  defmacro __using__(_opts) do
    quote do
      import Blog.SetSlug
    end
  end

  defmacro set_slug_from(field) do
    quote do
      defp set_slug(changeset) do
        if Ecto.Changeset.get_field(changeset, :slug) do
          changeset
        else
          slug = Ecto.Changeset.get_field(changeset, unquote(field))
          |> Slugger.slugify_downcase()
          Ecto.Changeset.put_change(changeset, :slug, slug)
        end
      end
    end
  end
end
