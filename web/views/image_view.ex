defmodule Blog.ImageView do
  use Blog.Web, :view

  def image_thumb(%{public_id: public_id}) do
    Cloudex.Url.for(public_id, %{transformation: "media_lib_thumb"})
  end

  def image_square(%{public_id: public_id}) do
    Cloudex.Url.for(public_id, %{height: 200})
  end

  def render("index.json", %{images: images}) do
    images
    |> Enum.map(fn image -> %{thumb: image_thumb(image), full: image_square(image), id: image.id } end)
  end
end
