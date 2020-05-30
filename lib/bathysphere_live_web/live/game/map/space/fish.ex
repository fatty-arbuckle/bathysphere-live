defmodule BathysphereLiveWeb.Game.Map.Space.Fish do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <span
        class="is-size-3 has-text-success"
        has-tooltip-multiline
        data-tooltip="Fish Discovery"
      >
        <i class="fas fa-fish"></i>
      </span>
    """
  end
end
