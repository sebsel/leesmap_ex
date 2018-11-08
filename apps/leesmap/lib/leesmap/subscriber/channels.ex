defmodule Leesmap.Subscriber.Channels do
  alias Neo4j.Sips, as: Neo4j

  @doc """
  Return a list of all channels that belong to a user.
  This list gets enhanced with a few build-in channels,
  which have their own special queries.
  """
  def list_channels(user) do
    cypher = ~s"""
    MATCH (user:User)-[:OWNS]->(channels:Channel)
    WHERE user.url = {user}
    RETURN channels
    """

    case query(cypher, %{"user" => user}) do
      {:ok, results} ->
        channels =
          Enum.map(results, fn %{"channels" => channels} -> channels end)
          |> add_buildin_channels()
          |> fake_unread_counts()

        {:ok, channels}
    end
  end

  defp add_buildin_channels(feeds) do
    notifications = %{"uid" => "notifications", "name" => "Notifications"}
    liked = %{"uid" => "liked", "name" => "Popular"}

    Enum.concat([notifications], feeds)
    |> Enum.concat([liked])
  end

  defp fake_unread_counts(feeds) do
    Enum.map(feeds, fn feed -> Map.put(feed, "unread", false) end)
  end

  @doc """
  Create a channel for the given user.
  """
  def create_channel(user, name) do
    uid = UUID.uuid4()

    cypher = ~s"""
    MATCH (user:User)
    WHERE user.url = {user}
    CREATE (user)-[:OWNS]->(:Channel {uid: {uid}, name: {name}})
    """

    case query(cypher, %{"user" => user, "uid" => uid, "name" => name}) do
      {:ok, _} -> {:ok, :success}
    end
  end

  @doc """
  Update a channel's name. Takes a user, to protect
  users from changing names for unowned channels.
  """
  def update_channel(user, channel, name) do
    cypher = ~s"""
    MATCH (user:User)-[:OWNS]->(channel:Channel)
    WHERE user.url = {user}
      AND channel.uid = {uid}
    SET channel.name = {name}
    """

    case query(cypher, %{"user" => user, "uid" => channel, "name" => name}) do
      {:ok, _} -> {:ok, :success}
    end
  end

  @doc """
  Delete a channel for a user.
  """
  def delete_channel(user, channel) do
    cypher = ~s"""
    MATCH (user:User)-[:OWNS]->(channel:Channel)
    WHERE user.url = {user}
      AND channel.uid = {uid}
    DETACH DELETE channel
    """

    # TODO also remove the feeds it follows!
    case query(cypher, %{"user" => user, "uid" => channel}) do
      {:ok, _} -> {:ok, :success}
    end
  end

  defp query(cypher, bindings) do
    Neo4j.query(Neo4j.conn, cypher, bindings)
  end
end
