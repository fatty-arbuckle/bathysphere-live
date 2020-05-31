defmodule BathysphereLiveWeb.PageLive do
  use BathysphereLiveWeb, :live_view


  @impl true
  def mount(_params, _session, socket) do
    {_state, game_state} = BathysphereLive.Backend.Game.state()
    {
      :ok,
      assign(socket,
        game_state: game_state,
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
      <button class="button" phx-click="reset-game">RESET</button>
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
        BathysphereLive.Backend.Game.reset(game_state)
        BathysphereLive.Backend.Game.state()
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
    BathysphereLive.Backend.Game.reset(%{ %BathysphereLive.Backend.Game.State{} | state: :no_map })
    {_state, game_state} = BathysphereLive.Backend.Game.state()
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
    move(die, idx, direction)
    {_state, game_state} = BathysphereLive.Backend.Game.state()
    {
      :noreply,
      assign(
        socket,
        game_state: game_state
      )
    }
  end
  def handle_event("dice-pool-reroll", _data, socket) do
    BathysphereLive.Backend.Game.reroll()
    {_state, game_state} = BathysphereLive.Backend.Game.state()
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
    BathysphereLive.Backend.Game.select_action({{String.to_atom(resource), value, false}, index})
    {_state, game_state} = BathysphereLive.Backend.Game.state()
    {
      :noreply,
      assign(
        socket,
        game_state: game_state
      )
    }
  end

  defp move(die, idx, "up"), do: BathysphereLive.Backend.Game.up(die, idx)
  defp move(die, idx, "down"), do: BathysphereLive.Backend.Game.down(die, idx)

end
