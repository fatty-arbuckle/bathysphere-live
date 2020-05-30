defmodule BathysphereLiveWeb.Game.Overview.Score do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="box has-background-grey-lighter has-text-left">
        <span class="has-text-info">
          Score:
        </span>
        <span class="">
         <%= @score %>
        </span>
      </div>

      <div class="box has-text-left has-background-grey-lighter">
        <span class="has-text-info">
          <i class="fas fa-fish"></i>
        </span>
        <%= for {value, idx} <- Enum.with_index(@fish_points) do %>
          <span class="<%= if idx < @fish_count, do: "has-text-success", else: "" %>">
            <%= pretty_value(value) %>
          </span>
        <% end %>
      </div>

      <div class="box has-text-left has-background-grey-lighter">
        <span class="has-text-info">
          <i class="fas fa-wind"></i>
        </span>
        <%= for {value, idx} <- Enum.with_index(@octopus_points) do %>
        <span class="<%= if idx < @octopus_count, do: "has-text-success", else: "" %>">
            <%= pretty_value(value) %>
          </span>
        <% end %>
      </div>
    """
  end

  defp pretty_value(value) when value > 0, do: "+#{value}"
  defp pretty_value(value), do: value

end
