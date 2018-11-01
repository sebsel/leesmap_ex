defmodule LeesmapWeb.MicrosubView do
  use LeesmapWeb, :view
  alias LeesmapWeb.MicrosubView

  def render("timeline.json", %{items: items}) do
    %{items: render_many(items, MicrosubView, "item.json"),
      paging: %{after: "", before: ""}}
  end

  def render("channels.json", %{channels: channels}) do
    %{channels: channels}
  end

  def render("item.json", %{microsub: item}) do
    item
  end

  def render("success.json", _) do
    %{success: "ok"}
  end
end
