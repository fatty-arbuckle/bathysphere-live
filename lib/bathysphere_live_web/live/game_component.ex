defmodule BathysphereLiveWeb.GameComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="has-text-centered">
      <div class="columns">

        <!-- Game Overview -->
        <div class="column">
          <%=
            live_component(
              @socket,
              BathysphereLiveWeb.Game.OverviewComponent,
              state: @game_state.state,
              dice_pool_size: @game_state.dice_pool_size,
              dice_pool: @game_state.dice_pool,
              score: @game_state.score,
              fish_points: @game_state.fish_points,
              octopus_points: @game_state.octopus_points,
              fish_count: @game_state.fish_count,
              octopus_count: @game_state.octopus_count,
              oxygen: @game_state.oxygen,
              stress: @game_state.stress,
              damage: @game_state.damage
            )
          %>
        </div>

        <!-- Game Map -->
        <div class="column" style="height:99vh; overflow-y: auto;">
          <%=
            live_component(@socket, BathysphereLiveWeb.Game.MapComponent, map: @game_state.map, position: @game_state.position)
          %>
        </div>

      </div>
    </div>
    """
  end
end
