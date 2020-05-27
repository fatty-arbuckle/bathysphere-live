defmodule BathysphereLiveWeb.Game.Map.Space.Damage do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class="<%= if @used?, do: "has-text-gray", else: "has-text-danger" %>"
      has-tooltip-multiline
      data-tooltip="Damage: <%= @value %>"
    >
      <i class="fas fa-ambulance"></i>
      <%= @value %>
    </span>
    """
  end
end
