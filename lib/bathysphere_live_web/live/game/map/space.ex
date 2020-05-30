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
      <span class="is-size-3 <%= if @current?, do: "has-text-info", else: "has-text-grey" %>">
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
      <span class="is-size-3 <%= current_text(@current?) %>">
        <i class="fas fa-cloud"></i>
      </span>
    </div>
    """
  end
  def render(assigns) do
    ~L"""
    <div class="box <%= current_background(@current?) %>">

      <%= if Enum.all?(@actions, fn {_, _, used?} -> used? end) do %>
        <span class="has-text-grey-lighter">
          <i class="fas fa-cloud"></i>
        </span>
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
            {:stress, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Stress, value: value, used?: used?, size: "is-size-3")
            {:oxygen, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Oxygen, value: value, used?: used?, size: "is-size-3")
            {:damage, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Damage, value: value, used?: used?, size: "is-size-3")
            {:ocean_floor, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.OceanFloor, value: value, used?: used?, size: "is-size-3")
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
