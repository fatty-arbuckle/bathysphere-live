defmodule BathysphereLiveWeb.Game.Control.Dead do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div>
        <span class="is-size-1 has-text-white">
          You are dead!
        </span>
      </div>
    """
  end

end
