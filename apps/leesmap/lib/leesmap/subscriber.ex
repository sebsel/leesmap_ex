defmodule Leesmap.Subscriber do
  alias Leesmap.Subscriber.Channels

  defdelegate list_channels(user), to: Channels
  defdelegate create_channel(user, name), to: Channels
  defdelegate update_channel(user, channel, name), to: Channels
  defdelegate delete_channel(user, channel), to: Channels
end
