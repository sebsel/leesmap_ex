defmodule Leesmap.Application do
  @moduledoc """
  The Leesmap Application Service.

  The leesmap system business domain lives in this application.

  Exposes API to clients such as the `LeesmapWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Leesmap.Repo, []),
      supervisor(Neo4j.Sips, [Application.fetch_env!(:leesmap, Neo4j)]),
    ], strategy: :one_for_one, name: Leesmap.Supervisor)
  end
end
