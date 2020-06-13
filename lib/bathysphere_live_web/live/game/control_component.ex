defmodule BathysphereLiveWeb.Game.ControlComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <article class="message is-primary">
        <div class="message-header">
          <span class="is-size-3">
           Control Panel
          </span>
        </div>
        <div class="message-body has-text-left">

          <div class="field is-grouped has-text-right">
            <p class="control">
              <div
                class="button is-text"
                has-tooltip-multiline
                data-tooltip="Reroll your dice"
                phx-click="dice-pool-reroll"
              >
                <span class="is-size-1 has-text-info">
                  <i class="fas fa-dice"></i>
                </span>
              </div>
            </p>
            <p class="control">
              <div
                class="button is-text"
                has-tooltip-multiline
                data-tooltip="Abandon the game"
                phx-click="reset-game"
              >
                <span class="is-size-1 has-text-danger">
                  <i class="fas fa-power-off"></i>
                </span>
              </div>
            </p>
          </div>

          <hr/>

          <%= case @state do
            :ok ->
              live_component(@socket, BathysphereLiveWeb.Game.Control.Dice, dice_pool: @resources.dice_pool)
            :dead ->
              live_component(@socket, BathysphereLiveWeb.Game.Control.Dead)
            {:select_action, choices} ->
              live_component(@socket, BathysphereLiveWeb.Game.Control.Selection, choices: choices, remaining: @remaining)
          end %>

          <hr/>

          <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Score,
            score: @score,
            fish_points: @fish_points,
            fish_count: @fish_count,
            octopus_points: @octopus_points,
            octopus_count: @octopus_count
          ) %>

          <hr/>

          <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resources, resources: @resources) %>
        </div>
      </article>
    """
  end

end
