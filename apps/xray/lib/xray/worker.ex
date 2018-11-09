defmodule Xray.Worker do

  def parse(url) do
    HTTPoison.start()

    params = URI.encode_query(%{url: URI.encode(url), expect: :feed})
    xray_url = "https://xray.p3k.io/parse?" <> params

    %{body: body} = HTTPoison.get!(xray_url)
    %{"data" => data, "code" => 200} = Poison.decode!(body)

    {:ok, data}
  end
end
