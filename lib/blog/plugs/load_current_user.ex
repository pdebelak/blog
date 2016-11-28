defmodule Blog.Plugs.LoadCurrentUser do
  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> Blog.CurrentUser.load_current_user()
  end
end
