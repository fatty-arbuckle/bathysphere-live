defmodule BathysphereLiveWeb.Game.Control.Score do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="has-text-left">
        <div class="row">
          <div class="columns">
            <div class="column is-one-fifth">
              <span class="is-size-3">
                <i class="fas fa-fish"></i>
              </span>
            </div>
            <div class="column">
              <%= for {value, idx} <- Enum.with_index(@fish_points) do %>
                <span class="is-size-3 <%= if idx < @fish_count, do: "has-text-success", else: "" %>">
                  <%= pretty_value(value) %>
                </span>
              <% end %>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="columns">
            <div class="column is-one-fifth">
              <span class="is-size-3">
                <i class="fas fa-wind"></i>
              </span>
            </div>
            <div class="column">
              <%= for {value, idx} <- Enum.with_index(@octopus_points) do %>
                <span class="is-size-3 <%= if idx < @octopus_count, do: "has-text-success", else: "" %>">
                  <%= pretty_value(value) %>
                </span>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    """
  end

  defp pretty_value(value) when value > 0, do: "+#{value}"
  defp pretty_value(value), do: value

end
