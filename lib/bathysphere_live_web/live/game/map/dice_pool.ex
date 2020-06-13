defmodule BathysphereLiveWeb.Game.Map.DicePool do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="row">
        <div class="columns">
          <!-- TODO: extract his 1-10-1 column pattern to share here and in space.ex -->
          <div class="column is-1 has-text-centered"></div>
          <div class="column is-10 has-text-centered">


          <div class="box">
          <div class="columns is-vcentered">
            <div class="column">
              <div
                class="button is-text"
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
                      class="button is-small is-primary is-light is-fullwidth has-text-success"
                    <% else %>
                      class="button is-small is-primary is-light is-fullwidth has-text-gray"
                      disabled
                    <% end %>
                  >
                    <span class="is-size-5">
                      <i class="fas fa-chevron-up"></i>
                    </span>
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
                      class="button is-small is-primary is-light is-fullwidth has-text-success"
                    <% else %>
                      class="button is-small is-primary is-light is-fullwidth has-text-gray"
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
          <div class="column is-1 has-text-centered"></div>
        </div>
      </div>





    """
  end
  # <article class="message is-primary has-text-centered">

  defp die(1), do: "fa-dice-one"
  defp die(2), do: "fa-dice-two"
  defp die(3), do: "fa-dice-three"
  defp die(4), do: "fa-dice-four"
  defp die(5), do: "fa-dice-five"
  defp die(6), do: "fa-dice-six"

end
