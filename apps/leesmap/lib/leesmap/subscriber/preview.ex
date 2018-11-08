defmodule Leesmap.Subscriber.Preview do

  def search(query) do
    results = [
      %{
        "type" => "feed",
        "url" => "https://aaronparecki.com/",
        "name" => "Aaron Parecki",
        "photo" => "https://aaronparecki.com/images/profile.jpg",
        "description" => "Aaron Parecki's home page"
      },
      %{
        "type" => "feed",
        "url" => "https://percolator.today/",
        "name" => "Percolator",
        "photo" => "https://percolator.today/images/cover.jpg",
        "description" => "A Microcast by Aaron Parecki",
        "author" => %{
          "name" => "Aaron Parecki",
          "url" => "https://aaronparecki.com/",
          "photo" => "https://aaronparecki.com/images/profile.jpg"
        }
      }
    ]
    {:ok, results}
  end

  def preview(url) do
    IO.inspect "HEALLO"
    # items = []
    # {:ok, items}
    Leesmap.Timeline.get_items_for_channel("liked")
    |> IO.inspect
  end
end
