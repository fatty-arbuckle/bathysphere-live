defmodule BathysphereLiveWeb.Game.Map.Space.Octopus do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class="has-text-success"
      has-tooltip-multiline
      data-tooltip="Octopus Discovery"
    >
      <i class="fas fa-wind"></i>
    </span>
    """
  end
end
