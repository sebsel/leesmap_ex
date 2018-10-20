use Mix.Config

config :leesmap, ecto_repos: [Leesmap.Repo]

import_config "#{Mix.env}.exs"
