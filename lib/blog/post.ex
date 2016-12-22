defmodule Blog.Post do
  use Blog.Web, :model
  use Blog.SetSlug

  set_slug_from(:title)

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :body, :string
    field :published_at, Ecto.DateTime
    field :publish, :boolean, virtual: true

    belongs_to :user, Blog.User
    has_many :comments, Blog.Comment
    many_to_many :tags, Blog.Tag, join_through: "posts_tags", on_replace: :delete

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

  defp set_published_at(changeset) do
    if Ecto.Changeset.get_field(changeset, :publish) && !Ecto.Changeset.get_field(changeset, :published_at) do
      Ecto.Changeset.put_change(changeset, :published_at, Ecto.DateTime.utc)
    else
      changeset
    end
  end

  def all_published(queryable) do
    queryable
    |> preload([:user, :tags])
    |> published()
    |> order_by(desc: :published_at)
  end

  def published(queryable) do
    from post in queryable,
    where: not is_nil(post.published_at)
  end

  def for_user(queryable, user) do
    from post in queryable,
    where: post.user_id == ^user.id
  end

  def for_tag(queryable, tag) do
    from post in queryable,
    join: tag in assoc(post, :tags),
    where: tag.slug == ^tag.slug
  end
end

defimpl Phoenix.Param, for: Blog.Post do
  def to_param(%{slug: slug}), do: slug
end
