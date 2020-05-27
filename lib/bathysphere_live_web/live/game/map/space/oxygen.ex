defmodule BathysphereLiveWeb.Game.Map.Space.Oxygen do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class="<%= if @used?, do: "has-text-gray", else: "has-text-danger" %>"
      has-tooltip-multiline
      data-tooltip="Oxygen: <%= @value %>"
    >
      <i class="fas fa-soap"></i>
      <%= @value %>
    </span>
    """
  end
end
