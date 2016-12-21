defmodule Blog.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :public_id, :string

      timestamps()
    end
  end
end
