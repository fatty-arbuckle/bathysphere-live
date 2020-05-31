defmodule BathysphereLiveWeb.Game.Map.DepthZone do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      has-tooltip-multiline
      data-tooltip="Depth zone"
    >
      <hr class="depth">
    </span>
    """
  end
end
