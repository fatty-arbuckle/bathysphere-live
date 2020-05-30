defmodule BathysphereLiveWeb.Game.Overview.Resources do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <article class="message is-primary">
      <div class="message-header">
        <span>
          Resources
        </span>
      </div>
      <div class="message-body">
        <div class="row">
          <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Resource, resource: @stress, label: "Stress", icon: "fa-exclamation-circle") %>
        </div>
        <div class="row">
          <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Resource, resource: @damage, label: "Damage", icon: "fa-skull") %>
        </div>
        <div class="row">
          <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Resource, resource: @oxygen, label: "Oxygen", icon: "fa-soap") %>
        </div>
      </div>
    </article>
    """
  end
end
