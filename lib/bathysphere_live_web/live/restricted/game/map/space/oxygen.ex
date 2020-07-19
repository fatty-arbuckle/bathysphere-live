defmodule BathysphereLiveWeb.Game.Map.Space.Oxygen do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class="<%= @size %> <%= if @used?, do: "has-text-gray", else: "has-text-danger" %>"
      has-tooltip-multiline
      data-tooltip="Oxygen <%= if @value != nil, do: ": #{@value}" %>"
    >
      <i class="fas fa-soap"></i>
      <%= if @value != nil do
        @value
      end %>
    </span>
    """
  end
end
