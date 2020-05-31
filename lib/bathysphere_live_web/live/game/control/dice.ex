defmodule BathysphereLiveWeb.Game.Control.Dice do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <article class="message is-primary has-text-centered">
        <div>
          <div class="columns is-vcentered">
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
                    <span class="is-size-3">
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
                    <span class="is-size-3">
                      <i class="fas fa-chevron-down"></i>
                    </span>
                  </li>
                </ul>
              </div>
            <% end %>
          </div>
        </div>
      </article>
    """
  end

  defp die(1), do: "fa-dice-one"
  defp die(2), do: "fa-dice-two"
  defp die(3), do: "fa-dice-three"
  defp die(4), do: "fa-dice-four"
  defp die(5), do: "fa-dice-five"
  defp die(6), do: "fa-dice-six"

end
