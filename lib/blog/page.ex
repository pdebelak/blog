defmodule Blog.Page do
  use Blog.Web, :model
  use Blog.SetSlug

  set_slug_from(:title)

  schema "pages" do
    field :title, :string
    field :slug, :string
    field :body, :string
    field :description, :string
    field :public, :boolean

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :slug, :body, :description, :public])
    |> set_slug()
    |> validate_required([:title, :slug, :body, :description])
    |> unique_constraint(:slug)
  end

  def public(queryable) do
    from page in queryable,
      where: page.public == true
  end
end

defimpl Phoenix.Param, for: Blog.Page do
  def to_param(%{slug: slug}), do: slug
end
