defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.{Post, CurrentUser}

  def index(conn, %{"username" => username}) do
    user = Blog.User
    |> preload(posts: :user)
    |> Repo.get_by!(username: username)
    render(conn, "index.html", posts: user.posts)
  end
  def index(conn, _params) do
    posts = Post |> preload(:user) |> Repo.all()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{user: CurrentUser.current_user(conn)}, post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => slug}) do
    post = Post |> preload(:user) |> Repo.get_by!(slug: slug)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => slug}) do
    post = Repo.get_by!(Post, slug: slug, user_id: CurrentUser.current_user(conn).id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => slug, "post" => post_params}) do
    post = Repo.get_by!(Post, slug: slug, user_id: CurrentUser.current_user(conn).id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => slug}) do
    post = Repo.get_by!(Post, slug: slug, user_id: CurrentUser.current_user(conn).id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
