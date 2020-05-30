defmodule BathysphereLiveWeb.Game.Map.Start do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="box <%= if @current?, do: "has-background-info", else: "has-background-grey-lighter" %>">
        <span class="is-size-3">
          <i class="fas fa-swimming-pool"></i>
        </span>
      </div>
    """
  end
end
