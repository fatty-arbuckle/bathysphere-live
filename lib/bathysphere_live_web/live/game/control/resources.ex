defmodule BathysphereLiveWeb.Game.Control.Resources do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="row">
        <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resource, resource: @resources.stress, label: "Stress") %>
      </div>
      <hr/>
      <div class="row">
        <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resource, resource: @resources.damage, label: "Damage") %>
      </div>
      <hr/>
      <div class="row">
        <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resource, resource: @resources.oxygen, label: "Oxygen") %>
      </div>
    """
  end
end
