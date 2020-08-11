defmodule BathysphereLiveWeb.PageLive do
  use BathysphereLiveWeb, :live_view


  @impl true
  def mount(_params, session, socket) do
    user = BathysphereLiveWeb.Restricted.Helper.get_user(session)
    {_state, game_state} = BathysphereLive.Backend.Game.state(user)
    {
      :ok,
      assign(socket,
        game_state: game_state,
        user: user,
        library: BathysphereLive.Backend.Library.Games.list()
      )
    }
  end

  @impl true
  def render(%{game_state: %{state: :no_map}} = assigns) do
    ~L"""
      <h1 class="title">
        Select a map to play
      </h1>
      <h2 class="subtitle">
        <ul>
          <%= for name <- @library do %>
            <button class="button" phx-click="select-map" phx-value-map-name="<%= name %>"><%= name %></li>
          <% end %>
        </ul>
      </h2>
    """
  end
  def render(assigns) do
    ~L"""
      <div>
        <%= live_component(
          @socket,
          BathysphereLiveWeb.GameComponent,
          game_state: @game_state)
        %>
      </div>
    """
  end

  @impl true
  def handle_event("select-map", %{ "map-name" => name }, socket) do
    {_state, game_state} = case BathysphereLive.Backend.Library.Games.load(name) do
      nil ->
        { :error, :game_not_found }
      game_state ->
        BathysphereLive.Backend.Game.reset(socket.assigns.user, game_state)
        BathysphereLive.Backend.Game.state(socket.assigns.user)
    end
    {
      :noreply,
      assign(
        socket,
        game_state: game_state,
        map_name: name
      )
    }
  end
  @impl true
  def handle_event("reset-game", _data, socket) do
    BathysphereLive.Backend.Game.reset(socket.assigns.user, %{ %BathysphereLive.Backend.Game.State{} | state: :no_map })
    {_state, game_state} = BathysphereLive.Backend.Game.state(socket.assigns.user)
    {
      :noreply,
      assign(
        socket,
        game_state: game_state,
        map_name: nil
      )
    }
  end
  def handle_event("dice-pool-selection", %{ "number" => value, "index" => index, "direction" => direction }, socket) do
    {die, _} = Integer.parse(value)
    {idx, _} = Integer.parse(index)
    move(socket.assigns.user, die, idx, direction)
    {_state, game_state} = BathysphereLive.Backend.Game.state(socket.assigns.user)
    {
      :noreply,
      assign(
        socket,
        game_state: game_state
      )
    }
  end
  def handle_event("dice-pool-reroll", _data, socket) do
    BathysphereLive.Backend.Game.reroll(socket.assigns.user)
    {_state, game_state} = BathysphereLive.Backend.Game.state(socket.assigns.user)
    {
      :noreply,
      assign(
        socket,
        game_state: game_state
      )
    }
  end
  def handle_event("select-option", %{ "resource" => resource, "cost" => cost, "used" => _used?, "index" => index }, socket) do
    {value, _} = Integer.parse(cost)
    BathysphereLive.Backend.Game.select_action(socket.assigns.user, {{String.to_atom(resource), value, false}, index})
    {_state, game_state} = BathysphereLive.Backend.Game.state(socket.assigns.user)
    {
      :noreply,
      assign(
        socket,
        game_state: game_state
      )
    }
  end

  defp move(user, die, idx, "up"), do: BathysphereLive.Backend.Game.up(user, die, idx)
  defp move(user, die, idx, "down"), do: BathysphereLive.Backend.Game.down(user, die, idx)

end
