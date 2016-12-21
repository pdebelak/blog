defmodule Blog.Image do
  use Blog.Web, :model

  schema "images" do
    field :public_id, :string
    field :file, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:file, :public_id])
    |> validate_required([:public_id])
  end
end
