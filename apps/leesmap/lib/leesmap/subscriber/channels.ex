defmodule Leesmap.Subscriber.Channels do
  alias Neo4j.Sips, as: Neo4j

  def list_channels(user) do
    cypher =
      ~s"""
      MATCH (user:User)-[:OWNS]->(channels:Channel)
      WHERE user.url = "#{user}"
      RETURN channels
      """

    case Neo4j.query(Neo4j.conn, cypher) do
      {:ok, results} ->
        channels = Enum.map(results, fn %{"channels" => channels} -> channels end)
        {:ok, channels}
    end
  end

  def create_channel(user, name) do
    uid = UUID.uuid4()
    cypher =
      ~s"""
      MATCH (user:User)
      WHERE user.url = "#{user}"
      CREATE (user)-[:OWNS]->(:Channel {uid: "#{uid}", name: "#{name}"})
      """

    case Neo4j.query(Neo4j.conn, cypher) do
      {:ok, _} -> {:ok, :success}
    end
  end

  def update_channel(user, channel, name) do
    cypher =
      ~s"""
      MATCH (user:User)-[:OWNS]->(channel:Channel)
      WHERE user.url = {user}
        AND channel.uid = {uid}
      SET channel.name = {name}
      """

    case Neo4j.query(Neo4j.conn, cypher, %{"user" => user, "uid" => channel, "name" => name}) do
      {:ok, _} -> {:ok, :success}
    end
  end

  def delete_channel(user, channel) do
    cypher =
      ~s"""
      MATCH (user:User)-[:OWNS]->(channel:Channel)
      WHERE user.url = {user}
        AND channel.uid = {uid}
      DETACH DELETE channel
      """

    # TODO also remove the feeds it follows!
    case Neo4j.query(Neo4j.conn, cypher, %{"user" => user, "uid" => channel}) do
      {:ok, _} -> {:ok, :success}
    end
  end
end
