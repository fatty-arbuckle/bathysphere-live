defmodule BathysphereLiveWeb.Game.Map.Space do
  use Phoenix.LiveComponent

  def update(%{space: {:space, %{ actions: actions, marked?: marked?} }, current?: current? } = _assigns, socket) do
    { :ok, assign(socket, actions: actions, marked?: marked?, current?: current? ) }
  end

  def render(%{marked?: true} = assigns) do
    ~L"""
      <div
        class="box <%= if @current?, do: "has-background-white", else: "has-background-grey" %>"
        has-tooltip-multiline
        data-tooltip="Marked space"
      >
        <span class="is-size-3 <%= if @current?, do: "has-text-white", else: "has-text-grey" %>">
          <i class="fas fa-cloud"></i>
        </span>
      </div>
    """
  end
  def render(%{actions: []} = assigns) do
    ~L"""
    <div
      class="box"
      has-tooltip-multiline
      data-tooltip="Empty space"
    >
      <span class="is-size-3 has-text-white">
        <i class="fas fa-cloud"></i>
      </span>
    </div>
    """
  end
  def render(assigns) do
    ~L"""
    <div class="box">

      <%= for { action, idx } <- Enum.with_index(@actions) do %>
        <%= if idx > 0 do %>
          <span class="is-size-3 has-text-weight-bold"> / </span>
        <% end %>
        <%=
          case action do
            {:discovery, :fish, _} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Fish, size: "is-size-3")
            {:discovery, :octopus, _} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Octopus, size: "is-size-3")
            {:stress, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Resource, resource: :stress, value: value, used?: used?, size: "is-size-3")
            {:oxygen, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Resource, resource: :oxygen, value: value, used?: used?, size: "is-size-3")
            {:damage, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Resource, resource: :damage, value: value, used?: used?, size: "is-size-3")
            {:ocean_floor, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.OceanFloor, value: value, used?: used?, size: "is-size-3")
          end
        %>
      <% end %>
    </div>
    """
  end

end
