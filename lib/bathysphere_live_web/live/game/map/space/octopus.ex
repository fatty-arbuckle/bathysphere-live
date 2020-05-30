defmodule BathysphereLiveWeb.Game.Map.Space.Octopus do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class="is-size-3 has-text-success"
      has-tooltip-multiline
      data-tooltip="Octopus Discovery"
    >
      <i class="fas fa-wind"></i>
    </span>
    """
  end
end
