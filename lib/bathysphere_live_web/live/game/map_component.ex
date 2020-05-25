defmodule BathysphereLiveWeb.Game.MapComponent do
  use Phoenix.LiveComponent

  def update(%{map: map, position: position} = _assigns, socket) do
    { :ok, assign(socket, map: map, position: position) }
  end

  def render(assigns) do
    ~L"""
    <div class="rows map-background">
      <%= for {{type, _data} = space, idx} <- Enum.with_index(@map) do %>
        <div class="row">
          <div class="columns">
            <div class="column is-1 has-text-centered"></div>

            <div class="column is-10 has-text-centered">
              <%= case type do
                :start ->
                  live_component(@socket, BathysphereLiveWeb.Game.Map.Start, current?: idx == @position)
                :space ->
                  live_component(@socket, BathysphereLiveWeb.Game.Map.Space, space: space, current?: idx == @position)
                :depth_zone ->
                  live_component(@socket, BathysphereLiveWeb.Game.Map.DepthZone)
              end %>
            </div>

            <div class="column is-1 has-text-centered"></div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
