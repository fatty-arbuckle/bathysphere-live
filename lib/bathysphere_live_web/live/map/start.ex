defmodule BathysphereLiveWeb.Map.Start do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="box <%= if @current?, do: "has-background-info", else: "has-background-grey-lighter" %>">
        <i class="fas fa-swimming-pool"></i>
      </div>
    """
  end
end
