defmodule BathysphereLiveWeb.Game.Overview.Selection do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <article class="message is-primary">
        <div class="message-header">
          Make a Selection
        </div>
        <div class="message-body has-text-centered">
          <div class="columns">
            <%= for {{resource, cost, used?}, index} <- @choices do %>
              <div class="column">
                <ul>
                  <li class="button is-small is-primary is-light is-fullwidth has-text-gray">
                    UP
                  </li>
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
                            live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Stress, value: cost, used?: used?, size: "is-size-1")
                          :oxygen ->
                            live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Oxygen, value: cost, used?: used?, size: "is-size-1")
                          :damage ->
                            live_component(@socket, BathysphereLiveWeb.Game.Map.Space.Damage, value: cost, used?: used?, size: "is-size-1")
                        end
                      %>
                    </button>
                  </li>
                  <li class="button is-small is-primary is-light is-fullwidth has-text-gray">
                    DOWN
                  </li>
                </ul>
              </div>
            <% end %>
          </div>
        </div>
      </article>
    """
  end



end
