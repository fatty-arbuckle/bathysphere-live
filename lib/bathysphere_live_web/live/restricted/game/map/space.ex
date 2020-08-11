defmodule BathysphereLiveWeb.Game.Map.Space do
  use Phoenix.LiveComponent

  def update(%{space: {:space, %{ actions: actions, marked?: marked?, tracking: tracking} }, current?: current? } = _assigns, socket) do
    { :ok, assign(socket, actions: actions, marked?: marked?, current?: current?, tracking: tracking ) }
  end
  def update(%{space: {:space, %{ actions: actions, marked?: marked?} }, current?: current? } = _assigns, socket) do
    { :ok, assign(socket, actions: actions, marked?: marked?, current?: current?, tracking: [] ) }
  end

  def render(%{marked?: true} = assigns) do
    ~L"""
      <div
        class="box is-less-transparent"
        has-tooltip-multiline
        data-tooltip="Marked space"
      >

        <%= if !@current? do %>
          <%= live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Tracking, tracking: @tracking) %>
        <% end %>

        <span class="is-size-3 has-text-invisible">
          <i class="fas fa-cloud"></i>
        </span>
      </div>
    """
  end
  def render(%{actions: []} = assigns) do
    ~L"""
    <div
      class="box is-transparent has-text-white"
      has-tooltip-multiline
      data-tooltip="Empty space"
    >
      <%= if !@current? do %>
        <%= live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Tracking, tracking: @tracking) %>
      <% end %>

      <span class="is-size-3 has-text-invisible">
        <i class="fas fa-cloud"></i>
      </span>
    </div>
    """
  end
  def render(assigns) do
    ~L"""
    <div class="box is-transparent">

      <%= if !@current? do %>
        <%= live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Tracking, tracking: @tracking) %>
      <% end %>

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
            {:ocean_floor, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.OceanFloor, value: value, used?: used?, size: "is-size-3")
            {resource_type, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Resource, resource: resource_type, value: value, used?: used?, size: "is-size-3")
          end
        %>
      <% end %>
    </div>
    """
  end

end
