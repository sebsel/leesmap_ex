use Mix.Config

# Configure your database
config :leesmap, Leesmap.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "leesmap_dev",
  hostname: "localhost",
  pool_size: 10
