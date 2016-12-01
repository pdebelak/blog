defmodule Blog.Post do
  use Blog.Web, :model

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :body, :string
    belongs_to :user, Blog.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body])
    |> set_slug()
    |> validate_required([:title, :slug, :body])
    |> unique_constraint(:slug)
  end

  defp set_slug(changeset) do
    slug = Ecto.Changeset.get_field(changeset, :title)
    |> Slugger.slugify_downcase()
    Ecto.Changeset.put_change(changeset, :slug, slug)
  end
end
