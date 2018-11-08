defmodule Leesmap.Subscriber do
  alias Leesmap.Subscriber.Preview
  alias Leesmap.Subscriber.Subscriptions
  alias Leesmap.Subscriber.Channels

  defdelegate search(url), to: Preview
  defdelegate preview(url), to: Preview

  defdelegate list_subscriptions(user, channel), to: Subscriptions
  defdelegate create_subscription(user, channel, url), to: Subscriptions

  defdelegate list_channels(user), to: Channels
  defdelegate create_channel(user, name), to: Channels
  defdelegate update_channel(user, channel, name), to: Channels
  defdelegate delete_channel(user, channel), to: Channels
end
