defmodule Blog.ImageUploader do
  @callback upload([String.t]) :: [%Blog.Image{}]

  def upload(paths) do
    Cloudex.upload(paths)
    |> Enum.map(fn {:ok, %{public_id: public_id}} -> %Blog.Image{public_id: public_id} end)
  end
end
