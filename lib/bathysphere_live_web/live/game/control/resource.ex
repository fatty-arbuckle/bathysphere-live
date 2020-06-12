defmodule BathysphereLiveWeb.Game.Control.Resource do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="columns is-vcentered">
      <div class="column has-text-left">
        <%= for %{type: type, used?: used?, penalties: penalties} <- @resource do %>
          <%=
            live_component(
              @socket,
              BathysphereLiveWeb.Game.Resources.Resource,
              type: type,
              value: nil,
              used?: translate_used(used?),
              size: "is-size-3"
            )
          %>
          <%= for penalty <- penalties do %>
            <span class="is-size-3">
              (
            </span>
            <%=
              live_component(
                @socket,
                BathysphereLiveWeb.Game.Resources.Resource,
                type: penalty,
                value: -1,
                used?: translate_used(used?),
                size: "is-size-3"
              )
            %>
            <span class="is-size-3">
              )
            </span>
          <% end %>
        <% end %>
      </div>
    </columns>
    """
  end

  # A false will render the wrong color, we need a nil
  defp translate_used(true), do: true
  defp translate_used(false), do: nil

end
