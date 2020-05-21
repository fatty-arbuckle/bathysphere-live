defmodule BathysphereLiveWeb.Map.Space.OceanFloor do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <span>OCEAN FLOOR <%= @value %></span>
    """
  end
end
