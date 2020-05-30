defmodule BathysphereLiveWeb.Game.Map.Space.Damage do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class="is-size-3 <%= if @used?, do: "has-text-gray", else: "has-text-danger" %>"
      has-tooltip-multiline
      data-tooltip="Damage: <%= @value %>"
    >
      <i class="fas fa-skull"></i>
      <%= @value %>
    </span>
    """
  end
end
