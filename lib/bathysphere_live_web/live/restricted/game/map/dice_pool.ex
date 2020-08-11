defmodule BathysphereLiveWeb.Game.Map.DicePool do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="row">
        <div class="box is-transparent">
          <div class="columns is-vcentered">
            <div class="column">
              <div
                class="button is-bordered-text"
                has-tooltip-multiline
                data-tooltip="Reroll your dice"
                phx-click="dice-pool-reroll"
              >
                <span class="is-size-1 has-text-white">
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
                      class="<%= die_select_class(used?) %>"
                    <% else %>
                      class="<%= die_select_class(used?) %>"
                      disabled
                    <% end %>
                  >
                    <span class="is-size-5">
                      <i class="fas fa-chevron-up"></i>
                    </span>
                  </li>
                  <li>
                    <span class="is-size-1 <%= if !used?, do: "has-text-white", else: "has-text-gray" %>">
                      <i class="fas <%= die(value) %>"></i>
                    </span>
                  </li>
                  <li
                    <%= if !used? do %>
                      phx-click="dice-pool-selection"
                      phx-value-number="<%= value %>"
                      phx-value-index="<%= index %>"
                      phx-value-direction="down"
                      class="<%= die_select_class(used?) %>"
                    <% else %>
                      class="<%= die_select_class(used?) %>"
                      disabled
                    <% end %>
                  >
                    <span class="is-size-5">
                      <i class="fas fa-chevron-down"></i>
                    </span>
                  </li>
                </ul>
              </div>
            <% end %>
          </div>
        </div>
      </div>





    """
  end

  defp die_select_class(used?), do: "button is-small is-transparent is-fullwidth " <> die_select_color(used?)

  defp die_select_color(false), do: "has-text-white"
  defp die_select_color(true), do: "has-text-gray"

  defp die(1), do: "fa-dice-one"
  defp die(2), do: "fa-dice-two"
  defp die(3), do: "fa-dice-three"
  defp die(4), do: "fa-dice-four"
  defp die(5), do: "fa-dice-five"
  defp die(6), do: "fa-dice-six"

end
