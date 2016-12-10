defmodule Blog.Fabricator do
  alias Blog.Repo

  def changeset(type), do: changeset(type, %{})
  def changeset(:user, params) do
    set_params = Map.merge(%{password: "password", username: Faker.Lorem.word}, params)
    Blog.User.changeset(%Blog.User{}, set_params)
  end
  def changeset(:post, params) do
    set_params = Map.merge(%{title: Faker.Lorem.sentence(10), body: Faker.Lorem.paragraph(%Range{first: 2, last: 4}), user: build(:user), publish: true}, params)
    Blog.Post.changeset(%Blog.Post{user: set_params.user}, set_params)
  end
  def changeset(:tag, params) do
    set_params = Map.merge(%{name: Faker.Lorem.word}, params)
    Blog.Tag.changeset(%Blog.Tag{}, set_params)
  end
  def changeset(:comment, params) do
    set_params = Map.merge(%{name: Faker.Lorem.word, body: Faker.Lorem.sentence(20), post: build(:post)}, params)
    Blog.Comment.changeset(%Blog.Comment{post: set_params.post}, set_params)
  end

  def build(type), do: build(type, %{})
  def build(type, params) do
    changeset(type, params) |> Ecto.Changeset.apply_changes()
  end

  def create(type), do: create(type, %{})
  def create(:post, params) do
    changeset(:post, params) |> Repo.insert!() |> Repo.preload(:user)
  end
  def create(type, params) do
    changeset(type, params) |> Repo.insert!()
  end

  def try_create(type), do: try_create(type, %{})
  def try_create(type, params) do
    changeset(type, params) |> Repo.insert()
  end
end
