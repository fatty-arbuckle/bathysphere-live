defmodule BathysphereLiveWeb.Game.Map.Space.Stress do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <span
        class="<%= @size %> <%= if @used?, do: "has-text-gray", else: "has-text-danger" %>"
        has-tooltip-multiline
        data-tooltip="Stress: <%= @value %>"
      >
        <i class="fas fa-exclamation-circle"></i>
        <%= @value %>
      </span>
    """
  end
end
