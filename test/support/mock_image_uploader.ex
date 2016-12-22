defmodule Blog.MockImageUploader do
  @behaviour Blog.ImageUploader

  def upload(paths) do
    for i <- 1..length(paths) do
      %Blog.Image{public_id: "public_id_#{i}"}
    end
  end
end
