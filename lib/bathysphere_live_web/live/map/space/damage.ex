defmodule BathysphereLiveWeb.Map.Space.Damage do
  use Phoenix.LiveComponent

  def render(%{used?: true} = assigns) do
    ~L"""
    """
  end
  def render(assigns) do
    ~L"""
    <span
      class=""
      has-tooltip-multiline
      data-tooltip="Damage: <%= @value %>"
    >
      <i class="fas fa-ambulance"></i>
      <%= @value %>
    </span>
    """
  end
end
