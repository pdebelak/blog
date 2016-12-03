defmodule Blog.Comment do
  use Blog.Web, :model

  schema "comments" do
    field :name, :string
    field :body, :string
    belongs_to :post, Blog.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :body])
    |> validate_required([:name, :body])
  end
end
