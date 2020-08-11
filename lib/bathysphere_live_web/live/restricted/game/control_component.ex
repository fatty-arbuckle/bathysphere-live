defmodule BathysphereLiveWeb.Game.ControlComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div>
        <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Score,
          score: @score,
          fish_points: @fish_points,
          fish_count: @fish_count,
          octopus_points: @octopus_points,
          octopus_count: @octopus_count
        ) %>
      </div>

      <div>
        <%= live_component(@socket, BathysphereLiveWeb.Game.Control.Resources, resources: @resources) %>
      </div>


      <div class="box is-transparent has-text-left has-text-white">
        <div class="row">
          <div class="columns">
            <div class="column">
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
            </div>
          </div>
        </div>
      </div>
    """
  end

end
