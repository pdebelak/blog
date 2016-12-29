defmodule Blog.PageControllerTest do
  use Blog.ConnCase

  alias Blog.{Page, Fabricator}
  @valid_attrs %{body: "some content", description: "some content", title: "some content"}
  @invalid_attrs %{body: ""}

  test "lists all entries on index", %{conn: conn} do
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> get(page_path(conn, :index))
    assert html_response(conn, 200) =~ "Pages"
  end

  test "renders form for new resources", %{conn: conn} do
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> get(page_path(conn, :new))
    assert html_response(conn, 200) =~ "New page"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> post(page_path(conn, :create), page: @valid_attrs)
    assert redirected_to(conn) == page_path(conn, :index)
    assert Repo.get_by(Page, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> post(page_path(conn, :create), page: @invalid_attrs)
    assert html_response(conn, 200) =~ "New page"
  end

  test "shows chosen resource", %{conn: conn} do
    page = Fabricator.create(:page)
    conn = get conn, page_path(conn, :show, page)
    assert html_response(conn, 200) =~ page.title
  end

  test "renders page not found when page is not public", %{conn: conn} do
    page = Fabricator.create(:page, %{public: false})
    assert_error_sent 404, fn ->
      get conn, page_path(conn, :show, page)
    end
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, page_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    page = Fabricator.create(:page)
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> get(page_path(conn, :edit, page))
    assert html_response(conn, 200) =~ "Edit page"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    page = Fabricator.create(:page)
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> put(page_path(conn, :update, page), page: @valid_attrs)
    assert redirected_to(conn) == page_path(conn, :show, page)
    assert Repo.get_by(Page, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    page = Fabricator.create(:page)
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> put(page_path(conn, :update, page), page: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit page"
  end

  test "deletes chosen resource", %{conn: conn} do
    page = Fabricator.create(:page)
    user = Fabricator.create(:user)
    conn = conn
    |> with_current_user(user)
    |> delete(page_path(conn, :delete, page))
    assert redirected_to(conn) == page_path(conn, :index)
    refute Repo.get(Page, page.id)
  end
end
