defmodule Xray do
  @moduledoc """
  Documentation for Xray.
  """

  defdelegate parse(url), to: Xray.Worker
end
