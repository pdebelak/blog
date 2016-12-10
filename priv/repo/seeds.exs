# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Blog.Fabricator

tag_names = ["Personal", "Work", "Off Topic", "Rant", "Posts"]

tags = for tag <- tag_names do
  Fabricator.create(:tag, %{name: tag})
end

for _ <- 1..2 do
  user = Fabricator.create(:user)
  for _ <- 1..15 do
    post = Fabricator.create(:post, %{user: user})
    for _ <- 1..5 do
      Fabricator.create(:comment, %{post: post})
    end
    post
    |> Blog.Repo.preload(:tags)
    |> Blog.Post.changeset(%{})
    |> Ecto.Changeset.put_assoc(:tags, Enum.take_random(tags, 2))
    |> Blog.Repo.update!
  end
end
