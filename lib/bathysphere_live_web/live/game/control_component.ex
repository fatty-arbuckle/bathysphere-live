defmodule BathysphereLiveWeb.Game.ControlComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""

      <%= case @state do
        :ok ->
          live_component(@socket, BathysphereLiveWeb.Game.Control.Dice, dice_pool: @dice_pool)
        :dead ->
          live_component(@socket, BathysphereLiveWeb.Game.Control.Dead)
        {:select_action, choices} ->
          live_component(@socket, BathysphereLiveWeb.Game.Control.Selection, choices: choices, remaining: @remaining)
      end %>

      <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Score,
        score: @score,
        fish_points: @fish_points,
        fish_count: @fish_count,
        octopus_points: @octopus_points,
        octopus_count: @octopus_count
      ) %>

      <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resources,
        oxygen: @oxygen,
        stress: @stress,
        damage: @damage
      ) %>
    """
  end

end
