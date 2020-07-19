defmodule BathysphereLiveWeb.Game.Map.Space.Damage do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class="<%= @size %> <%= text_color(@used?) %>"
      has-tooltip-multiline
      data-tooltip="Damage <%= if @value != nil, do: ": #{@value}" %>"
    >
      <i class="fas fa-skull"></i>
      <%= if @value != nil do
        @value
      end %>
    </span>
    """
  end

  def text_color(nil), do: "has-text-success"
  def text_color(false), do: "has-text-danger"
  def text_color(true), do: "has-text-gray"

end
