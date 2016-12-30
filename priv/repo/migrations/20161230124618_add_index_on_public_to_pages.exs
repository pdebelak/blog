defmodule Blog.Repo.Migrations.AddIndexOnPublicToPages do
  use Ecto.Migration

  def change do
    create index(:pages, [:public])
  end
end
