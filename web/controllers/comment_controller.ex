defmodule Blog.CommentController do
  use Blog.Web, :controller

  alias Blog.Comment

  def index(conn, params = %{"post_id" => post_id}) do
    post = Repo.get_by!(Blog.Post, slug: post_id)
    page = Comment
    |> where(post_id: ^post.id)
    |> Repo.paginate(params)
    render(conn, "index.html", comments: page.entries, post: post, pagination: page)
  end

  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    post = Repo.get_by!(Blog.Post, slug: post_id)
    changeset = Comment.changeset(%Comment{post_id: post.id}, comment_params)

    case Repo.insert(changeset) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Thank you for commenting!")
        |> redirect(to: post_path(conn, :show, post))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Your comment could not be created.")
        |> redirect(to: post_path(conn, :show, post))
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comment |> preload(:post) |> Repo.get!(id)
    Repo.delete!(comment)
    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: post_comment_path(conn, :index, comment.post))
  end
end
