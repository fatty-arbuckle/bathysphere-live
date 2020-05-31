defmodule BathysphereLiveWeb.Game.Control.Resource do
  use Phoenix.LiveComponent

  # <div class="column is-one-fifth">
  #   <span class="is-size-4 has-text-info">
  #     <%= @label %>
  #   </span>
  # </div>

  def render(assigns) do
    ~L"""
    <div class="columns is-vcentered">
      <div class="column has-text-left">
        <%= for {_, used?} <- @resource do %>
          <span class="is-size-3 <%= if !used?, do: "has-text-success", else: "" %>">
            <i class="fas <%= @icon %>"></i>
          </span>
        <% end %>
      </div>
    </columns>
    """
  end
end
