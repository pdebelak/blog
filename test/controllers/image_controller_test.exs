defmodule Blog.ImageControllerTest do
  use Blog.ConnCase

  alias Blog.Fabricator

  test "lists all images on index", %{conn: conn} do
    image = Fabricator.create(:image)
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> get(image_path(conn, :index))
    assert json_response(conn, 200) |> List.first() |> Map.get("full") =~ image.public_id
  end

  test "creates image and renders all images", %{conn: conn} do
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> post(image_path(conn, :create), image: %{"file" => [%Plug.Upload{path: "a_path"}]})
    image = Blog.Repo.one(Blog.Image)
    assert json_response(conn, 200) |> List.first() |> Map.get("full") =~ image.public_id
  end
end
