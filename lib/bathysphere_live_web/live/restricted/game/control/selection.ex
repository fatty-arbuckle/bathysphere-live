defmodule BathysphereLiveWeb.Game.Control.Selection do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <div class="box is-transparent has-text-white">
        <div class="">
          <span class="has-text-left">
            Make a Selection
          </span>
          <span class="has-text-right">
            <%= @remaining %> spaces to go
          </span>
        </div>
        <div class="has-text-centered">
          <div class="columns">
            <%= for {{resource, cost, used?}, index} <- @choices do %>
              <div class="column">
                <ul>
                  <li class="button is-small is-text is-fullwidth" disabled></li>
                  <li>
                    <div
                      phx-click="select-option"
                      phx-value-resource="<%= resource %>"
                      phx-value-cost="<%= cost %>"
                      phx-value-used="<%= used? %>"
                      phx-value-index="<%= index %>"
                    >
                      <%=
                        case resource do
                          :stress ->
                            live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Stress, value: cost, used?: used?, size: "is-size-3")
                          :oxygen ->
                            live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Oxygen, value: cost, used?: used?, size: "is-size-3")
                          :damage ->
                            live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Damage, value: cost, used?: used?, size: "is-size-3")
                        end
                      %>
                    </button>
                  </li>
                  <li class="button is-small is-text is-fullwidth" disabled></li>
                </ul>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    """
  end



end
