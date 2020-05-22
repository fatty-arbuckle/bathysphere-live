defmodule BathysphereLiveWeb.Map.Space.Octopus do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      has-tooltip-multiline
      data-tooltip="Octopus Discovery"
    >
      <i class="fas fa-3x fa-wind"></i>
    </span>
    """
  end
end
