defmodule BathysphereLiveWeb.Game.OverviewComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="box has-background-grey-lighter">
        <div class="columns is-vcentered">
          <div class="column">
            <div
              class="button is-grey-lighter has-background-grey-lighter"
              has-tooltip-multiline
              data-tooltip="Reroll your dice"
              phx-click="dice-pool-reroll"
            >
              <span class="is-size-1 has-text-info">
                <i class="fas fa-dice"></i>
              </span>
            </div>
          </div>
          <%= for {value, index, used?} <- @dice_pool do %>
            <div class="column">
              <ul>
                <li
                  <%= if !used? do %>
                    phx-click="dice-pool-selection"
                    phx-value-number="<%= value %>"
                    phx-value-index="<%= index %>"
                    phx-value-direction="up"
                    class="has-text-success"
                  <% else %>
                    class="has-text-gray"
                  <% end %>
                >
                  UP
                </li>
                <li>
                  <span class="is-size-1 <%= if !used?, do: "has-text-success", else: "has-text-gray" %>">
                    <i class="fas <%= die(value) %>"></i>
                  </span>
                </li>
                <li
                  <%= if !used? do %>
                    phx-click="dice-pool-selection"
                    phx-value-number="<%= value %>"
                    phx-value-index="<%= index %>"
                    phx-value-direction="down"
                    class="has-text-success"
                  <% else %>
                    class="has-text-gray"
                  <% end %>
                >
                  DOWN
                </li>
              </ul>
            </div>
          <% end %>
        </div>
      </div>

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

      <%= live_component(@socket, BathysphereLiveWeb.Game.Map.Overview.Resource, resource: @oxygen, label: "Oxygen", icon: "fa-soap") %>
      <%= live_component(@socket, BathysphereLiveWeb.Game.Map.Overview.Resource, resource: @stress, label: "Stress", icon: "fa-exclamation-circle") %>
      <%= live_component(@socket, BathysphereLiveWeb.Game.Map.Overview.Resource, resource: @damage, label: "Damage", icon: "fa-ambulance") %>

    """
  end

  defp die(1), do: "fa-dice-one"
  defp die(2), do: "fa-dice-two"
  defp die(3), do: "fa-dice-three"
  defp die(4), do: "fa-dice-four"
  defp die(5), do: "fa-dice-five"
  defp die(6), do: "fa-dice-six"

  defp pretty_value(value) when value > 0, do: "+#{value}"
  defp pretty_value(value), do: value


end
