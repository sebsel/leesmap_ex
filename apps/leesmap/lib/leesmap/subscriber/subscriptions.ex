defmodule Leesmap.Subscriber.Subscriptions do
  alias Neo4j.Sips, as: Neo4j

  def list_subscriptions(user, channel) do
    cypher = ~s"""
    MATCH (user:User)-[:OWNS]->(channel:Channel)
    MATCH (channel)-[:SUBSCRIBED]->(feeds:Feed)
    WHERE user.url = {user}
      AND channel.uid = {channel}
    RETURN feeds, channel
    """

    case query(cypher, %{"user" => user, "channel" => channel}) do
      {:ok, results} ->
        feeds = Enum.map(results, fn %{"feeds" => feeds} -> feeds end)
        {:ok, feeds}
    end
  end

  def create_subscription(user, channel, url) do
    cypher = ~s"""
    MATCH (user:User)-[:OWNS]->(channel:Channel)
    WHERE user.url = {user}
      AND channel.uid = {channel}
    CREATE (channel)-[:SUBSCRIBED]->(:Feed {url: {url}})
    """

    case query(cypher, %{"user" => user, "channel" => channel, "url" => url}) do
      {:ok, _} -> {:ok, :success}
    end
  end


  defp query(cypher, bindings) do
    Neo4j.query(Neo4j.conn, cypher, bindings)
  end
end
