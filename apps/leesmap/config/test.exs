use Mix.Config

# Configure your database
config :leesmap, Leesmap.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "leesmap_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
