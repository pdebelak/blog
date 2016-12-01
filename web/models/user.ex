defmodule Blog.User do
  use Blog.Web, :model

  schema "users" do
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params) do
    struct
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> update_change(:username, &String.downcase/1)
    |> hash_password()
    |> unique_constraint(:username)
  end
  def changeset(params \\ %{}), do: changeset(%__MODULE__{}, params)

  defp hash_password(%{valid?: false} = changeset), do: changeset
  defp hash_password(%{valid?: true} = changeset) do
    hashedpw = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
    Ecto.Changeset.put_change(changeset, :password_hash, hashedpw)
  end

  @doc """
  Checks if a user exists with given `username` and `password`. Returns either
  `{:ok, user}` or `{:error, changeset}`
  """
  def authenticate(%{"username" => username, "password" => password} = params) do
    user = Blog.Repo.get_by(__MODULE__, username: username)
    cond do
      user == nil -> {:error, changeset(params)}
      Comeonin.Bcrypt.checkpw(password, user.password_hash) -> {:ok, user}
      true -> {:error, changeset(params)}
    end
  end
end
