defmodule Blog.PageController do
  use Blog.Web, :controller

  alias Blog.Page

  def index(conn, params) do
    page = Page
    |> Repo.paginate(params)
    render(conn, "index.html", pages: page.entries, pagination: page)
  end

  def new(conn, _params) do
    changeset = Page.changeset(%Page{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"page" => page_params}) do
    changeset = Page.changeset(%Page{}, page_params)

    case Repo.insert(changeset) do
      {:ok, _page} ->
        conn
        |> put_flash(:info, "Page created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    page = Page
    |> Page.public()
    |> Repo.get_by!(slug: id)
    render(conn, "show.html", page: page)
  end

  def edit(conn, %{"id" => id}) do
    page = Repo.get_by!(Page, slug: id)
    changeset = Page.changeset(page)
    render(conn, "edit.html", page: page, changeset: changeset)
  end

  def update(conn, %{"id" => id, "page" => page_params}) do
    page = Repo.get_by!(Page, slug: id)
    changeset = Page.changeset(page, page_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Page updated successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", page: page, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    page = Repo.get_by!(Page, slug: id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(page)

    conn
    |> put_flash(:info, "Page deleted successfully.")
    |> redirect(to: page_path(conn, :index))
  end
end
