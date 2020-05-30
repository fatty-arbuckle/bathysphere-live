defmodule BathysphereLiveWeb.Game.OverviewComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""

      <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Dice,
        dice_pool: @dice_pool
      ) %>

      <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Score,
        score: @score,
        fish_points: @fish_points,
        fish_count: @fish_count,
        octopus_points: @octopus_points,
        octopus_count: @octopus_count
      ) %>

      <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Resource, resource: @oxygen, label: "Oxygen", icon: "fa-soap") %>
      <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Resource, resource: @stress, label: "Stress", icon: "fa-exclamation-circle") %>
      <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Resource, resource: @damage, label: "Damage", icon: "fa-skull") %>

    """
  end

end
