defmodule BathysphereLiveWeb.Game.Map.Space.Resource do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <%= live_component(
        @socket,
        BathysphereLiveWeb.Game.Resources.Resource,
        type: @resource,
        value: @value,
        used?: @used?,
        size: @size
      ) %>
    """
  end

end
