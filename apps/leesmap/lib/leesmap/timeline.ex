defmodule Leesmap.Timeline do

  def get_items_for_channel(_) do
    {:ok, [%{id: 1}, %{id: 2}, %{id: 3}]}
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
