use Mix.Config

config :leesmap, ecto_repos: [Leesmap.Repo]

import_config "#{Mix.env}.exs"

config :leesmap, Neo4j,
  url: "http://localhost:7474",
  pool_size: 5,
  max_overflow: 2,
  timeout: 15_000,  # milliseconds!
  basic_auth: [username: "neo4j", password: "graphdb"]
