defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.{Post, CurrentUser}

  def index(conn, params = %{"tag" => tag}) do
    tag = Repo.get_by!(Blog.Tag, slug: tag)
    page = Post
    |> Post.all_published()
    |> Post.for_tag(tag)
    |> Repo.paginate(params)
    render(conn, "tag.html", posts: page.entries, tag: tag, pagination: page)
  end
  def index(conn, params = %{"username" => username}) do
    user = Repo.get_by!(Blog.User, username: username)
    page = Post
    |> Post.all_published()
    |> Post.for_user(user)
    |> Repo.paginate(params)
    render(conn, "user.html", posts: page.entries, user: user, pagination: page)
  end
  def index(conn, params) do
    page = Post
    |> Post.all_published()
    |> Repo.paginate(params)
    render(conn, "index.html", posts: page.entries, pagination: page)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Blog.UpdatePost.update_post(%Post{user: CurrentUser.current_user(conn)}, post_params) do
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
    |> preload([:user, :comments, :tags])
    |> Post.published()
    |> Repo.get_by!(slug: slug)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => slug}) do
    post = Post
    |> Post.for_user(CurrentUser.current_user(conn))
    |> preload(:tags)
    |> Repo.get_by!(slug: slug)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => slug, "post" => post_params}) do
    post = Post
    |> Post.for_user(CurrentUser.current_user(conn))
    |> preload(:tags)
    |> Repo.get_by!(slug: slug)
    case Blog.UpdatePost.update_post(post, post_params) do
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
