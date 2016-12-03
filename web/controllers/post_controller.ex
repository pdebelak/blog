defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.{Post, CurrentUser}

  def index(conn, %{"username" => username}) do
    user = Repo.get_by!(Blog.User, username: username)
    posts = Post
    |> Post.all_published()
    |> Post.for_user(user)
    |> Repo.all()
    render(conn, "index.html", posts: posts)
  end
  def index(conn, _params) do
    posts = Post
    |> Post.all_published()
    |> Repo.all()
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
    post = Post
    |> preload([:user, :comments])
    |> Post.published()
    |> Repo.get_by!(slug: slug)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => slug}) do
    post = Post
    |> Post.for_user(CurrentUser.current_user(conn))
    |> Repo.get_by!(slug: slug)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => slug, "post" => post_params}) do
    post = Post
    |> Post.for_user(CurrentUser.current_user(conn))
    |> Repo.get_by!(slug: slug)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Blog.DashboardView.smart_post_path(conn, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => slug}) do
    post = Post
    |> Post.for_user(CurrentUser.current_user(conn))
    |> Repo.get_by!(slug: slug)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
