defmodule BathysphereLiveWeb.Map.Space.Fish do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <span
        has-tooltip-multiline
        data-tooltip="Fish Discovery"
      >
        <i class="fas fa-fish"></i>
      </span>
    """
  end
end
