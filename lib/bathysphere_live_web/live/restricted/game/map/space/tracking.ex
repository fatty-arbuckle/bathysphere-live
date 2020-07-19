defmodule BathysphereLiveWeb.Game.Map.Space.Tracking do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="is-pulled-left">
        <%= for { direction } <- @tracking do %>
          <span
            class="has-text-dark is-size-3"
          >
            <i class="fas <%= direction_icon(direction) %>"></i>
          </span>
        <% end %>
      </div>
    """
  end

  defp direction_icon(:up), do: "fa-long-arrow-alt-up"
  defp direction_icon(:down), do: "fa-long-arrow-alt-down"
  defp direction_icon(:unknown), do: "fa-sort-question-circle"

end
