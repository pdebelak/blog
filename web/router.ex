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

    get "/", PageController, :index
  end

  scope "/admin", Blog do
    pipe_through [:browser, :admin]

  end

  # Other scopes may use custom stacks.
  # scope "/api", Blog do
  #   pipe_through :api
  # end
end
