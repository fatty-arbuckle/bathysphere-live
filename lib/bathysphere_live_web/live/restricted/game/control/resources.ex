defmodule BathysphereLiveWeb.Game.Control.Resources do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div>
      <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resource, resource: @resources.stress, label: "Stress") %>
    </div>
    <div>
      <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resource, resource: @resources.damage, label: "Damage") %>
    </div>
    <div>
      <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resource, resource: @resources.oxygen, label: "Oxygen") %>
    </div>
    """
  end
end
