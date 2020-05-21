defmodule BathysphereLiveWeb.MapComponent do
  use Phoenix.LiveComponent

  def update(%{map: map, position: position} = _assigns, socket) do
    { :ok, assign(socket, map: map, position: position) }
  end

  def render(assigns) do
    ~L"""
    <div class="rows">
      <%= for {{type, data} = space, idx} <- Enum.with_index(@map) do %>
        <div class="row">
          <div class="columns">
            <div class="column is-1 has-text-centered"></div>

            <div class="column is-10 <%= if idx == @position, do: "has-background-danger", else: "has-background-info" %> has-text-centered">
              <%= case type do
                :start ->
                  live_component(@socket, BathysphereLiveWeb.Map.Start)
                :space ->
                  live_component(@socket, BathysphereLiveWeb.Map.Space, space: space)
                :depth_zone ->
                  live_component(@socket, BathysphereLiveWeb.Map.DepthZone)
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
