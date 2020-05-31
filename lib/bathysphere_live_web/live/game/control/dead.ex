defmodule BathysphereLiveWeb.Game.Control.Dead do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <article class="message is-primary">
        <div class="message-header">
          Game Over!
        </div>
        <div class="message-body has-text-centered">
          <div>
            <span class="is-size-1">
              You are dead!
            </span>
          </div>
        </div>
      </article>
    """
  end

end
