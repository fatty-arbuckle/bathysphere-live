defmodule BathysphereLiveWeb.Game.ControlComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <article class="message is-primary">
        <div class="message-header">
          <span class="is-size-3">
           Control Panel
          </span>
          <span class="control">
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
          </span>

        </div>
        <div class="message-body has-text-left">

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
