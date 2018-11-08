defmodule LeesmapWeb.MicrosubController do
  use LeesmapWeb, :controller
  alias Leesmap.Timeline
  alias Leesmap.Subscriber

  @doc ~S"""
  Timeline actions.
  """
  def endpoint(
        %{method: "GET"} = conn,
        %{
          "action" => "timeline",
          "channel" => channel
        }
      ) do
    {:ok, items} = Timeline.get_items_for_channel(channel)
    render(conn, "timeline.json", items: items)
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "timeline",
          "method" => "mark_read",
          "channel" => _channel,
          "last_read_entry" => _entry
        }
      ) do
    not_implemented(conn)
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "timeline",
          "method" => "mark_read",
          "channel" => _channel,
          "entry" => _entry
        }
      ) do
    not_implemented(conn)
  end

  @doc ~S"""
  Channel actions.
  """
  def endpoint(
        %{method: "GET"} = conn,
        %{
          "action" => "channels"
        }
      ) do
    {:ok, channels} = Subscriber.list_channels(conn.user)
    json(conn, %{"channels" => channels})
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "channels",
          "name" => name,
          "channel" => channel
        }
      ) do
    {:ok, :success} = Subscriber.update_channel(conn.user, channel, name)
    render(conn, "success.json")
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "channels",
          "name" => name
        }
      ) do
    {:ok, :success} = Subscriber.create_channel(conn.user, name)
    render(conn, "success.json")
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "channels",
          "method" => "delete",
          "channel" => channel
        }
      ) do
    {:ok, :success} = Subscriber.delete_channel(conn.user, channel)
    render(conn, "success.json")
  end

  @doc ~S"""
  Search.
  """
  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "search",
          "channel" => _channel,
          "query" => _query
        }
      ) do
    not_implemented(conn)
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "search",
          "query" => query
        }
      ) do
    {:ok, results} = Subscriber.search(query)
    json(conn, %{"results" => results})
  end

  @doc ~S"""
  Preview.
  """
  def endpoint(
        %{method: "GET"} = conn,
        %{
          "action" => "preview",
          "url" => url
        }
      ) do
    {:ok, items} = Subscriber.preview(url)
    json(conn, %{"items" => items})
  end

  @doc ~S"""
  Following.
  """
  def endpoint(
        %{method: "GET"} = conn,
        %{
          "action" => "follow",
          "channel" => channel
        }
      ) do
    {:ok, items} = Subscriber.list_subscriptions(conn.user, channel)
    json(conn, %{"items" => items})
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "follow",
          "channel" => channel,
          "url" => url
        }
      ) do
    Subscriber.create_subscription(conn.user, channel, url)
    render(conn, "success.json")
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "unfollow",
          "channel" => _channel,
          "url" => _url
        }
      ) do
    not_implemented(conn)
  end

  @doc ~S"""
  Muting.
  """
  def endpoint(
        %{method: "GET"} = conn,
        %{
          "action" => "mute",
          "channel" => _channel
        }
      ) do
    not_implemented(conn)
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "mute",
          "channel" => _channel,
          "url" => _url
        }
      ) do
    not_implemented(conn)
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "unmute",
          "channel" => _channel,
          "url" => _url
        }
      ) do
    not_implemented(conn)
  end

  @doc ~S"""
  Blocking.
  """
  def endpoint(
        %{method: "GET"} = conn,
        %{
          "action" => "block",
          "channel" => _channel
        }
      ) do
    not_implemented(conn)
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "block",
          "channel" => _channel,
          "url" => _url
        }
      ) do
    not_implemented(conn)
  end

  def endpoint(
        %{method: "POST"} = conn,
        %{
          "action" => "unblock",
          "channel" => _channel,
          "url" => _url
        }
      ) do
    not_implemented(conn)
  end

  @doc ~S"""
  Error handling when nothing matches the request.
  """
  def endpoint(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "invalid_request"})
  end

  defp not_implemented(conn) do
    conn
    |> put_status(:not_implemented)
    |> json(%{error: "not_implemented", message: "Sorry! Need more time :)"})
  end
end
