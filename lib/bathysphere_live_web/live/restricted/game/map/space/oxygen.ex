defmodule BathysphereLiveWeb.Game.Map.Space.Oxygen do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class="<%= @size %> has-text-white"
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
