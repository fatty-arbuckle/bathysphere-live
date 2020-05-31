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
        <%= for {resource, used?} <- @resource do %>
          <%= case resource do
            :stress ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Resource, resource: :stress, value: nil, used?: translate_used(used?), size: "is-size-3")
            :oxygen ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Resource, resource: :oxygen, value: nil, used?: translate_used(used?), size: "is-size-3")
            :damage ->
              live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Resource, resource: :damage, value: nil, used?: translate_used(used?), size: "is-size-3")
          end %>
        <% end %>
      </div>
    </columns>
    """
  end

  # A false will render the wrong color, we need a nil
  defp translate_used(true), do: true
  defp translate_used(false), do: nil

end
