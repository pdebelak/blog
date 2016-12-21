defmodule Blog.UploadImagesTest do
  use Blog.ConnCase, async: true

  alias Blog.{Repo, Image}
  import Blog.UploadImages

  test "handles no images" do
    assert upload_images(nil) == nil
  end

  test "uploads an image" do
    [{:ok, image}] = upload_images([%{path: "image1"}])
    assert Repo.get_by(Image, public_id: image.public_id)
  end

  test "uploads multiple images" do
    upload_images([%{path: "image1"}, %{path: "image2"}])
    assert Repo.aggregate(Image, :count, :id) == 2
  end
end
