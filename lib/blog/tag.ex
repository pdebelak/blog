defmodule Blog.Tag do
  use Blog.Web, :model
  use Blog.SetSlug

  set_slug_from(:name)

  schema "tags" do
    field :name, :string
    field :slug, :string

    many_to_many :posts, Blog.Post, join_through: "posts_tags"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> set_slug()
    |> validate_required([:name, :slug])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end
end

defimpl Phoenix.Param, for: Blog.Tag do
  def to_param(%{slug: slug}), do: slug
end
