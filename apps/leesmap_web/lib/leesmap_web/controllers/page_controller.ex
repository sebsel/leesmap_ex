defmodule LeesmapWeb.PageController do
  use LeesmapWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
