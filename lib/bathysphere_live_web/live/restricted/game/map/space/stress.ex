defmodule BathysphereLiveWeb.Game.Map.Space.Stress do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <span
        class="<%= @size %> has-text-white"
        has-tooltip-multiline
        data-tooltip="Stress <%= if @value != nil, do: ": #{@value}" %>"
      >
        <i class="fas fa-exclamation-circle"></i>
        <%= if @value != nil do
          @value
        end %>
      </span>
    """
  end
end
