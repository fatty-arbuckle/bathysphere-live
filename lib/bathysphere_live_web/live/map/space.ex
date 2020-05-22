defmodule BathysphereLiveWeb.Map.Space do
  use Phoenix.LiveComponent

  def update(%{space: {:space, %{ actions: actions, marked?: marked?} }, current?: current? } = _assigns, socket) do
    { :ok, assign(socket, actions: actions, marked?: marked?, current?: current? ) }
  end

  def render(%{marked?: true} = assigns) do
    ~L"""
    <div
      class="box has-background-grey"
      has-tooltip-multiline
      data-tooltip="Marked space"
    >
      MARKED
    </div>
    """
  end
  def render(%{actions: []} = assigns) do
    ~L"""
    <div
      class="box <%= current_format(@current?) %>"
      has-tooltip-multiline
      data-tooltip="Empty space"
    >
      <span class="is-size-3 has-text-white">
        <i class="fas fa-cloud"></i>
      </span>
    </div>
    """
  end
  def render(%{actions: actions} = assigns) do
    ~L"""
    <div class="box <%= current_format(@current?) %>">
      <%= for { action, idx } <- Enum.with_index(@actions) do %>
        <%= if idx > 0 do %>
          <span class="is-size-3 has-text-weight-bold"> / </span>
        <% end %>
        <%=
          case action do
            {:discovery, :fish, _} ->
              live_component(@socket, BathysphereLiveWeb.Map.Space.Fish)
            {:discovery, :octopus, _} ->
              live_component(@socket, BathysphereLiveWeb.Map.Space.Octopus)
            {:stress, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Map.Space.Stress, value: value, used?: used?)
            {:oxygen, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Map.Space.Oxygen, value: value, used?: used?)
            {:damage, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Map.Space.Damage, value: value, used?: used?)
            {:ocean_floor, value, used?} ->
              live_component(@socket, BathysphereLiveWeb.Map.Space.OceanFloor, value: value, used?: used?)
          end
        %>
      <% end %>
    </div>
    """
  end

  defp current_format(true), do: "has-background-info"
  defp current_format(false), do: "has-background-grey-lighter"

end
