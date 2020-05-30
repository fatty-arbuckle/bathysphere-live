defmodule BathysphereLiveWeb.Game.Map.Start do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="box">
        <span class="is-size-3">
          <i class="fas fa-swimming-pool"></i>
        </span>
      </div>
    """
  end
end
