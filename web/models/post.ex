defmodule Blog.Post do
  use Blog.Web, :model

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :body, :string
    field :published_at, Ecto.DateTime
    field :publish, :boolean, virtual: true
    belongs_to :user, Blog.User
    has_many :comments, Blog.Comment

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :publish])
    |> set_slug()
    |> set_published_at()
    |> validate_required([:title, :slug, :body])
    |> unique_constraint(:slug)
  end

  defp set_slug(changeset) do
    if Ecto.Changeset.get_field(changeset, :slug) do
      changeset
    else
      slug = Ecto.Changeset.get_field(changeset, :title)
      |> Slugger.slugify_downcase()
      Ecto.Changeset.put_change(changeset, :slug, slug)
    end
  end

  defp set_published_at(changeset) do
    if Ecto.Changeset.get_field(changeset, :publish) && !Ecto.Changeset.get_field(changeset, :published_at) do
      Ecto.Changeset.put_change(changeset, :published_at, Ecto.DateTime.utc)
    else
      changeset
    end
  end

  def all_published(queryable) do
    queryable
    |> preload(:user)
    |> published()
    |> order_by(desc: :published_at)
  end

  def published(queryable) do
    queryable
    |> where(fragment("published_at IS NOT NULL"))
  end

  def for_user(queryable, user) do
    queryable
    |> where(user_id: ^user.id)
  end
end

defimpl Phoenix.Param, for: Blog.Post do
  def to_param(%{slug: slug}), do: slug
end
