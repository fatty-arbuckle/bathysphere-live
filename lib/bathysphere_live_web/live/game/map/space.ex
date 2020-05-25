defmodule BathysphereLiveWeb.Game.Map.Space do
  use Phoenix.LiveComponent

  def update(%{space: {:space, %{ actions: actions, marked?: marked?} }, current?: current? } = _assigns, socket) do
    { :ok, assign(socket, actions: actions, marked?: marked?, current?: current? ) }
  end

  def render(%{marked?: true} = assigns) do
    ~L"""
    <div
      class="box <%= if @current?, do: "has-background-info", else: "has-background-grey" %>"
      has-tooltip-multiline
      data-tooltip="Marked space"
    >
      <span class="<%= if @current?, do: "has-text-info", else: "has-text-grey" %>">
        <i class="fas fa-cloud"></i>
      </span>
    </div>
    """
  end
  def render(%{actions: []} = assigns) do
    ~L"""
    <div
      class="box <%= current_background(@current?) %>"
      has-tooltip-multiline
      data-tooltip="Empty space"
    >
      <span class="<%= current_text(@current?) %>">
        <i class="fas fa-cloud"></i>
      </span>
    </div>
    """
  end
  def render(assigns) do
    ~L"""
    <div class="box <%= current_background(@current?) %>">
      <%= for { action, idx } <- Enum.with_index(@actions) do %>
        <%= if idx > 0 do %>
          <span class="has-text-weight-bold"> / </span>
        <% end %>
        <%=
          case action do
            {:discovery, :fish, _} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Fish)
            {:discovery, :octopus, _} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Octopus)
            {:stress, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Stress, value: value, used?: used?)
            {:oxygen, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Oxygen, value: value, used?: used?)
            {:damage, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Damage, value: value, used?: used?)
            {:ocean_floor, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.OceanFloor, value: value, used?: used?)
          end
        %>
      <% end %>
    </div>
    """
  end

  defp current_background(true), do: "has-background-info"
  defp current_background(false), do: "has-background-grey-lighter"

  defp current_text(true), do: "has-text-info"
  defp current_text(false), do: "has-text-grey-lighter"

end
