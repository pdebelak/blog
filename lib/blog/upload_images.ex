defmodule Blog.UploadImages do
  @image_uploader Application.get_env(:blog, :image_uploader)

  def upload_images(nil), do: nil
  def upload_images(%Plug.Upload{} = file), do: upload_images([file])
  def upload_images(files) do
    files
    |> Enum.map(fn %{path: path} -> path end)
    |> @image_uploader.upload()
    |> Enum.map(&Blog.Repo.insert/1)
  end
end
