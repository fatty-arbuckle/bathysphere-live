defmodule BathysphereLiveWeb.Game.OverviewComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""

      <%= case @state do
        :ok ->
          live_component(@socket, BathysphereLiveWeb.Game.Overview.Dice, dice_pool: @dice_pool)
        :dead ->
          live_component(@socket, BathysphereLiveWeb.Game.Overview.Dead)
        {:select_action, choices} ->
          live_component(@socket, BathysphereLiveWeb.Game.Overview.Selection, choices: choices)
      end %>

      <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Score,
        score: @score,
        fish_points: @fish_points,
        fish_count: @fish_count,
        octopus_points: @octopus_points,
        octopus_count: @octopus_count
      ) %>

      <%= live_component(@socket, BathysphereLiveWeb.Game.Overview.Resources,
        oxygen: @oxygen,
        stress: @stress,
        damage: @damage
      ) %>
    """
  end

end
