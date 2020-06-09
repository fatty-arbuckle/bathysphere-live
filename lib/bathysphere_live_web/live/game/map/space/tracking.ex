defmodule BathysphereLiveWeb.Game.Map.Space.Tracking do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="is-pulled-left">
        <%= for { info, direction } <- @tracking do %>
          <span
            class="has-text-dark is-size-3"
            has-tooltip-multiline
            data-tooltip="<%= info %>"
          >
            <i class="fas <%= direction_icon(direction) %>"></i>
          </span>
        <% end %>
      </div>
    """
  end

  defp direction_icon(:up), do: "fa-chevron-up"
  defp direction_icon(:down), do: "fa-chevron-down"
  defp direction_icon(:unknown), do: "fa-sort-question-circle"

end
