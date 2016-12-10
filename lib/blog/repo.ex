defmodule Blog.Repo do
  use Ecto.Repo, otp_app: :blog
  use Scrivener, page_size: 10
end
