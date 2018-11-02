defmodule LeesmapWeb.Router do
  use LeesmapWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :microsub do
    plug :accepts, ["json"]
    plug :indieauth
  end

  scope "/", LeesmapWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/microsub", LeesmapWeb do
    pipe_through :microsub
    get "/", MicrosubController, :endpoint
    post "/", MicrosubController, :endpoint
  end

  # TODO don't fake this
  def indieauth(conn, _opts), do: Map.put(conn, :user, "seblog.nl/")
end
