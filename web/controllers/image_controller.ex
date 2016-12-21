defmodule Blog.ImageController do
  use Blog.Web, :controller

  alias Blog.{Image, Repo}

  def index(conn, _params) do
    images = Repo.all(Image)
    conn
    |> put_layout(false)
    |> render("index.json", images: images)
  end

  def create(conn, %{"image" => image_params}) do
    Blog.UploadImages.upload_images(image_params["file"])
    images = Repo.all(Image)
    conn
    |> put_layout(false)
    |> render("index.json", images: images)
  end
end
