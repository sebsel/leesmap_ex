defmodule Leesmap.Timeline do
  alias Neo4j.Sips, as: Neo4j

  def get_items_for_channel(channel) do
    {query, bindings} =
      case channel do
        "liked" ->
          {
            """
            MATCH (entry:Entry)-[:LIKES]->(liked:Entry)
            WITH liked, count(entry) AS likes
            RETURN liked AS item, id(liked) AS id
              ORDER BY likes DESC, liked.published DESC
              LIMIT 100
            """,
            %{}
          }

        "latest" ->
          {
            """
            MATCH (entry:Entry)
            RETURN entry AS item, id(entry) AS id
              ORDER BY entry.published DESC
              LIMIT 100
            """,
            %{}
          }

        "checkin" ->
          {
            """
            MATCH (entry:Entry {post_type: "checkin"})
            RETURN entry AS item, id(entry) AS id
              ORDER BY entry.published DESC
              LIMIT 100
            """,
            %{}
          }

        _ ->
          {
            """
            MATCH (channel:Channel)-[:HAS]->(entry:Entry)
            WHERE channel.uid = {channel}
            RETURN entry as item, id(entry) as id
              ORDER BY entry.published DESC
              LIMIT 100
            """,
            %{"channel" => channel}
          }
      end

    {:ok, results} = Neo4j.query(Neo4j.conn(), query, bindings)

    items =
      Enum.map(results, fn %{"item" => %{"content" => content}, "id" => id} ->
        content
        |> Poison.decode!()
        |> Map.put(:_id, id)
        |> Map.put(:_is_read, true)
      end)

    {:ok, items}
  end

  def mark_read(_, _) do
    # ..
    {:ok, :success}
  end

  def mark_read_after(_, _) do
    # ..
    {:ok, :success}
  end
end
