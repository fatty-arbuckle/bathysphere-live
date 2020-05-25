defmodule BathysphereLiveWeb.Game.Map.Overview.Resource do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="box has-text-left has-background-grey-lighter">
      <div class="has-text-info">
        <%= @label %>
      </div>
      <%= for {_, used?} <- @resource do %>
        <span class="<%= if !used?, do: "has-text-success", else: "" %>">
        <i class="fas <%= @icon %>"></i>
        </span>
      <% end %>
    </div>
    """
  end
end
