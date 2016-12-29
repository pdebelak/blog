defmodule Blog.Router do
  use Blog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Blog.Plugs.LoadCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug Blog.Plugs.RequireCurrentUser
  end

  scope "/", Blog do
    pipe_through :browser

    get "/admin", SessionController, :new
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete

    resources "/posts", PostController, only: [:show] do
      resources "/comments", CommentController, only: [:create]
    end

    resources "/page", PageController, only: [:show]

    get "/", PostController, :index
    get "/authors/:username", PostController, :index, as: "author_posts"
    get "/tags/:tag", PostController, :index, as: "tag_posts"
  end

  scope "/admin", Blog do
    pipe_through [:browser, :admin]

    resources "/dashboard", DashboardController, only: [:index]
    post "/post-preview", PostController, :preview
    resources "/posts", PostController, only: [:new, :create, :edit, :update, :delete] do
      resources "/comments", CommentController, only: [:index]
    end
    resources "/comments", CommentController, only: [:delete]
    resources "/images", ImageController, only: [:index, :create]
    resources "/pages", PageController, only: [:index, :new, :create, :edit, :update, :delete]
  end
end
