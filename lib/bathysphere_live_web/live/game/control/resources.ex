defmodule BathysphereLiveWeb.Game.Control.Resources do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="row">
        <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resource, resource: @stress, label: "Stress") %>
      </div>
      <hr/>
      <div class="row">
        <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resource, resource: @damage, label: "Damage") %>
      </div>
      <hr/>
      <div class="row">
        <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resource, resource: @oxygen, label: "Oxygen") %>
      </div>
    """
  end
end
