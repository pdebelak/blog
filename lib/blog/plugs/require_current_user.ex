defmodule Blog.Plugs.RequireCurrentUser do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case Blog.CurrentUser.current_user(conn) do
      nil ->
        conn
        |> send_resp(401, "Not authorized")
        |> halt()
      _ -> conn
    end
  end
end
