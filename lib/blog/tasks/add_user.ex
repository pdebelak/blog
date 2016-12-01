defmodule Mix.Tasks.AddUser do
  use Mix.Task
  alias Blog.{User, Repo}

  @shortdoc "Creates a user with given username and password in the database."
  def run(args) do
    Mix.Task.run "app.start", []
    {:ok, user} = User.changeset(parse_args(args))
    |> Repo.insert()
    Mix.shell.info "User #{user.username} created!"
  end

  defp parse_args(args) do
    args
    |> Enum.map(fn arg ->
      [key, value] = String.split(arg, ":")
      {key, value}
    end)
    |> Enum.into(%{})
  end
end
