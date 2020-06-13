defmodule BathysphereLiveWeb.GameComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="has-text-centered">
      <div class="columns">

        <!-- Control Panel -->
        <div class="column">
          <%=
            live_component(
              @socket,
              BathysphereLiveWeb.Game.ControlComponent,
              state: @game_state.state,
              score: @game_state.score,
              fish_points: @game_state.fish_points,
              octopus_points: @game_state.octopus_points,
              fish_count: @game_state.fish_count,
              octopus_count: @game_state.octopus_count,
              resources: @game_state.resources,
              remaining: @game_state.remaining
            )
          %>
        </div>

        <!-- Game Map -->
        <div class="column map-container">
          <%=
            live_component(@socket, BathysphereLiveWeb.Game.MapComponent, map: @game_state.map, position: @game_state.position)
          %>
        </div>

      </div>
    </div>
    """
  end
end
