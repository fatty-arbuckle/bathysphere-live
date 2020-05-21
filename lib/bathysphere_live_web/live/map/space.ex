defmodule BathysphereLiveWeb.Map.Space do
  use Phoenix.LiveComponent

  def update(%{space: {:space, %{ actions: actions, marked?: marked?} } } = _assigns, socket) do
    { :ok, assign(socket, actions: actions, marked?: marked? ) }
  end

  def render(%{marked?: true} = assigns) do
    ~L"""
    <div>
      MARKED
    </div>
    """
  end
  def render(%{actions: nil} = assigns) do
    ~L"""
    <div>
      NIL
    </div>
    """
  end
  def render(%{actions: []} = assigns) do
    ~L"""
    <div>
      EMPTY
    </div>
    """
  end
  def render(%{actions: actions} = assigns) do
    ~L"""
    <div>
      <%= for action <- @actions do %>
        <%= case action do %>
          <% {:discovery, :fish, _} -> %>
            <%= live_component(@socket, BathysphereLiveWeb.Map.Space.Fish) %>
          <% {:discovery, :octopus, _} -> %>
            <%= live_component(@socket, BathysphereLiveWeb.Map.Space.Octopus) %>
          <% {:stress, value, used?} -> %>
            <%= live_component(@socket, BathysphereLiveWeb.Map.Space.Stress, value: value, used?: used?) %>
          <% {:oxygen, value, used?} -> %>
            <%= live_component(@socket, BathysphereLiveWeb.Map.Space.Oxygen, value: value, used?: used?) %>
          <% {:damage, value, used?} -> %>
            <%= live_component(@socket, BathysphereLiveWeb.Map.Space.Damage, value: value, used?: used?) %>
          <% {:ocean_floor, value, used?} -> %>
            <%= live_component(@socket, BathysphereLiveWeb.Map.Space.OceanFloor, value: value, used?: used?) %>
        <% end %>
      <% end %>
    </div>
    """
  end

end
